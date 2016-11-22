//
//  ViewController.m
//  MapKaoQin
//
//  Created by yaoshuai on 2016/11/22.
//  Copyright © 2016年 yaoshuai. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>

@interface ViewController ()<MAMapViewDelegate>

@property (weak, nonatomic) IBOutlet MAMapView *mapV;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

/**
 目标位置
 */
@property (strong, nonatomic) MAPointAnnotation *destiantationPoint;

@property (weak, nonatomic) IBOutlet UILabel *coordinateLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ///初始化地图
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 400)];
    
    // 1. 显示用户的位置
    mapView.showsUserLocation = YES;
    
    // 2. 跟踪用户的位置 - 可以将用户定位在地图的中心，并且放大地图，有的时候，速度会有些慢！
    mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    // 3. 允许后台定位 - 保证 Background Modes 中的 Location updates 处于选中状态
    mapView.allowsBackgroundLocationUpdates = YES;
    
    // 4. 不允许系统暂停位置更新
    mapView.pausesLocationUpdatesAutomatically = NO;
    
    mapView.delegate = self;
    
    ///把地图添加至view
    [self.view addSubview:mapView];
    
    _mapV = mapView;
    
    [self addDestinationPosition];
}

#pragma mark - 添加目标地点
- (void)addDestinationPosition{
    // 1. 实例化大头针
    MAPointAnnotation *annotaion = [MAPointAnnotation new];
    
    // 2. 指定坐标位置
    annotaion.coordinate = CLLocationCoordinate2DMake(39.901603, 116.406643);
    
    // 3. 添加到地图视图
    [_mapV addAnnotation:annotaion];
    _destiantationPoint = annotaion;
}

#pragma mark - MAMapViewDelegate
/**
 * @brief 位置或者设备方向更新后，会调用此函数
 * @param mapView 地图View
 * @param userLocation 用户定位信息(包括位置与设备方向等数据) 是一个固定的对象
 * @param updatingLocation 标示是否是location数据更新, YES:location数据更新 NO:heading数据更新
 */
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
    // 0. 判断 `位置数据` 是否变化 - 不一定是经纬度变化！
    if (!updatingLocation) {
        return;
    }
    
    // 大概 1s 更新一次！
    // NSLog(@"%@ %p", userLocation.location, userLocation.location);
    
    // 1. 实例化大头针
    MAPointAnnotation *annotaion = [MAPointAnnotation new];
    
    // 2. 指定坐标位置
    annotaion.coordinate = userLocation.location.coordinate;
    
    // 3. 添加到地图视图
    [mapView addAnnotation:annotaion];
    
    _coordinateLabel.text = [NSString stringWithFormat:@"我的位置：%f-%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude];
    
    CLLocation *destation = [[CLLocation alloc] initWithLatitude:_destiantationPoint.coordinate.latitude longitude:_destiantationPoint.coordinate.longitude];
    double distance = [userLocation.location distanceFromLocation:destation];
    _distanceLabel.text = [NSString stringWithFormat:@"距离：%f",distance];
    
    _stateLabel.text = distance < 50 ? @"可打卡" : @"不能打卡";
}

@end

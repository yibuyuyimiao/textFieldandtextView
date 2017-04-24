//
//  ViewController.m
//  TableViewAndTextView
//
//  Created by kalian on 2017/4/20.
//  Copyright © 2017年 kalian. All rights reserved.
//

#import "ViewController.h"
#import "textFieldCell.h"
#import "textView.h"

@interface ViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property(assign,nonatomic)CGFloat keyboardHeight;
@property(strong,nonatomic)textFieldCell *SelectedCell;

@end

@implementation ViewController


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.tableView reloadData];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- tableViewDataSourchDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        static NSString *identifier=@"textFieldCell";
    
         textFieldCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
         if (cell==nil) {
             
                 cell= [[[NSBundle mainBundle]loadNibNamed:@"textFieldCell" owner:nil options:nil] firstObject];
             }
    cell.OSTextField.delegate = self;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 20;
}

#pragma mark -- UITextField


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"1");//输入文字时 一直监听
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    self.SelectedCell = (textFieldCell*)[[textField superview] superview];
    
//    NSLog(@"height== >%f",textField.frame.size.height);
//    NSLog(@"%f",textField.frame.origin.y);
    
//    NSLog(@"2");// 准备开始输入  文本字段将成为第一响应者
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    NSLog(@"3");//文本彻底结束编辑时调用
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    NSLog(@"4");//返回一个BOOL值，指定是否循序文本字段开始编辑
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
//    NSLog(@"5");// 点击‘x’清除按钮时 调用
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
//    NSLog(@"6");//返回BOOL值，指定是否允许文本字段结束编辑，当编辑结束，文本字段会让出第一响应者
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    NSLog(@"7");// 点击键盘的‘换行’会调用
    return YES;
}

#pragma mark -- 键盘出现和消失的方法

/* 1、用 setContentOffset:代替视图的平移
 
   2、self.tableView.contentOffset.y +CGRectGetMaxY(self.SelectedCell.frame)得到的结果不稳定  使用下边办法解决
 
 
 
 */

- (void)keyboardWillShow:(NSNotification *)notification {
    
    
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    _keyboardHeight = keyboardRect.size.height;
    
    CGRect tableViewRect = [self.tableView convertRect:self.SelectedCell.frame toView:self.view];

    //得出键盘距离输入框的间距
    CGFloat transformY =CGRectGetMaxY(tableViewRect) -CGRectGetMaxY(keyboardRect) ;
    
    if (transformY > 0) {
       
        CGPoint scrollPoint = CGPointMake(0.0, -transformY);
        [self.tableView setContentOffset:scrollPoint animated:YES];
        
       
    }
    
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, _keyboardHeight, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
      NSLog(@"--------%f=========%f",self.tableView.contentOffset.y,CGRectGetMaxY(self.SelectedCell.frame));

}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
      NSLog(@"+++++++++++%f",self.tableView.contentOffset.y);

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    NSLog(@"--------+++++++++++%f",self.tableView.contentOffset.y);
   
}

@end

//
//  BookListViewController.m
//  WillyHustedBookList
//
//  Created by Willy Husted on 6/25/15.
//
//

#import "BookListViewController.h"
#import "MBProgressHUD.h"

@interface BookListViewController ()

@end

@implementation BookListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getListOfBooks];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.booksArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Load next book title in array
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSObject *book = [self.booksArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [book valueForKey:@"title"];
   
    
    // Load and display image
    NSString *imageURL = [book valueForKey:@"imageURL"];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageURL]];
    cell.imageView.image = [UIImage imageWithData: imageData];
    return cell;
}

#pragma mark - Helper methods

-(NSArray *)serializeJSON:(NSData *)data {
    NSError *parsingError = nil;
    NSArray *books = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parsingError];
    return books;
}

-(void)getListOfBooks {
    NSURL *URL = [NSURL URLWithString:@"http://de-coding-test.s3.amazonaws.com/books.json"];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:URL];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"Error"); // TODO: handle error
        } else {
            self.booksArray = [self serializeJSON:data];
            // booksArray now populated - reload
            [self.tableView reloadData];
        }
    }];
}


@end

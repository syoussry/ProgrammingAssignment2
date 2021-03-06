## The two functions below work in pair
## makeCacheMatrix enables to store the inverse of a matrix in the cache
## cacheSolve calculates the inverse of the "special matrix"
## created in makeCacheMatrix OR returns a previously calculated inverse
## stored in the cache

## makeCacheMatrix function
#this function takes a matrix as input
#returns a list of four functions as output
#these functions enable to store the inverse of x in the cache
#and access its value without having to compute it once more

makeCacheMatrix <- function(x = matrix()) {

  #i is the inverse matrix
  i <- NULL
  
  #set function
  #used to set the value of the initial matrix
  set <- function(y) {
    x <<- y
    i <<- NULL
  }
  
  #get functioon
  #used to get the value of the initial matrix
  get <- function() x
  
  #setinverse function
  #set the inverse of the matrix x after calculating it
  setinverse <- function(inversematrix) i <<- inversematrix
  
  #getinverse function
  #get the inverse of the matrix x stored in the "special matrix"
  getinverse <- function() i
  
  #returns the list of four functions above
  list(set = set, get = get,
       setinverse = setinverse,
       getinverse = getinverse)
  
}


## cacheSolve function
## returns the inverse of a matrix
## gets its cached value if previously calculated
## calculates it otherwise

cacheSolve <- function(x, ...) {
  ## Return a matrix i that is the inverse of 'x'
  ## assuming x is always invertible
  ## the "..." can be used to add parameters to solve
  ## check ?solve to see which parameters can be added
  ## example: tolerance, LINPACK etc.
  
  # get the cached inverse
  i <- x$getinverse()
  # check if i has been previously calculated
  if(!is.null(i)) {
    message("getting cached data")
    # if yes then return it, no further calculation required
    return(i)
  }
  
  #otherwise calculate the inverse of x and return it
  data <- x$get()
  i <- solve(data, ...)
  x$setinverse(i)
  i
}


## tests

#define a 2*2 matrix X
X<-matrix(c(1,2,3,4),nrow=2)
#check if X is invertible
det(X)!=0
#create a "special" matrix x
x<-makeCacheMatrix(X)
#get the value of the matrix
x$get()
#set another value for the matrix
x$set(matrix(c(4,3,2,1),nrow=2))
#check the new value
x$get()
#check if the new value is invertible
det(x$get())!=0
#check that no inverse exists
x$getinverse()
#calculate the inverse, adding a tolerance parameter
cacheSolve(x,tol=1e-8)
#checking the inverse has been stored
x$getinverse()
#checking it is indeed x's matrix inverse
x$get() %*% x$getinverse() == diag(2)
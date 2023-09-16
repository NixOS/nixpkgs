{ qtModule
, qtbase
, libwebp
, jasper
, libmng
, libtiff
}:

qtModule {
  pname = "qtimageformats";
  propagatedBuildInputs = [ qtbase libwebp jasper libmng libtiff ];
}

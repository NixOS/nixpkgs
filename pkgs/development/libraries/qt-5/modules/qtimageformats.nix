{ qtModule
, qtbase
, libwebp
, jasper
, libmng
, libtiff
}:

qtModule {
  pname = "qtimageformats";
  qtInputs = [ qtbase ];
  propagatedBuildInputs = [ libwebp jasper libmng libtiff ];
}

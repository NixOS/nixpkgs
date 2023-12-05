{ qtModule
, qtbase
, libwebp
, jasper
, libmng
, libtiff
}:

qtModule {
  pname = "qtimageformats";
  propagatedBuildInputs = [ qtbase ];
  buildInputs = [ libwebp jasper libmng libtiff ];
}

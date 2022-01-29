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
  buildInputs = [ libwebp jasper libmng libtiff ];
  outputs = [ "out" "dev" "bin" ];
}

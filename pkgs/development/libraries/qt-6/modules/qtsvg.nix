{ qtModule
, qtbase
, libwebp
, jasper
, libmng
, zlib
, pkg-config
}:

qtModule {
  pname = "qtsvg";
  qtInputs = [ qtbase ];
  buildInputs = [ libwebp jasper libmng zlib ];
  nativeBuildInputs = [ pkg-config ];
}

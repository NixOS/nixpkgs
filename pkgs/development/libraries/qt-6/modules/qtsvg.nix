{ qtModule
, qtbase
, libwebp
, jasper
, libmng
, zlib
, pkg-config # find libwebp
}:

qtModule {
  pname = "qtsvg";
  qtInputs = [ qtbase ];
  buildInputs = [ libwebp jasper libmng zlib ];
  nativeBuildInputs = [ pkg-config ];
  outputs = [ "out" "dev" "bin" ];
}

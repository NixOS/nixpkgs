{ qtModule
, qtbase
, libwebp
, jasper
, libmng
, zlib
, pkg-config
, openssl
, qtserialport
, qtdeclarative
}:

# TODO? optional dependency: gconf

qtModule {
  pname = "qtpositioning";
  outputs = [ "out" "dev" "bin" ];
  qtInputs = [ qtbase qtdeclarative qtserialport ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];
}

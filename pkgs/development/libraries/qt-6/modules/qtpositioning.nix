{ qtModule
, qtbase
, qtdeclarative
, qtserialport
, pkg-config
, openssl
}:

qtModule {
  pname = "qtpositioning";
  qtInputs = [ qtbase qtdeclarative qtserialport ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];
}

{ qtModule
, lib
, stdenv
, qtbase
, qtdeclarative
, bluez
, pkg-config
}:

qtModule {
  pname = "qtconnectivity";
  qtInputs = [ qtbase qtdeclarative ];
  buildInputs = [ bluez ];
  nativeBuildInputs = [ pkg-config ];
}

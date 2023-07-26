{ qtModule
, lib
, stdenv
, qtbase
, qtdeclarative
, bluez
, pkg-config
, IOBluetooth
, PCSC
}:

qtModule {
  pname = "qtconnectivity";
  qtInputs = [ qtbase qtdeclarative ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optionals stdenv.isLinux [ bluez ];
  propagatedBuildInputs = lib.optionals stdenv.isDarwin [ IOBluetooth PCSC ];
}

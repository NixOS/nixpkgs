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
  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optionals stdenv.isLinux [ bluez ];
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ] ++ lib.optionals stdenv.isDarwin [
    IOBluetooth
    PCSC
  ];
}

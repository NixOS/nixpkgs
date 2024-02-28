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
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ bluez ];
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    IOBluetooth
    PCSC
  ];
}

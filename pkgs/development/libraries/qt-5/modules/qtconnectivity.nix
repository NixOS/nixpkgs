{ qtModule, lib, stdenv, qtbase, qtdeclarative, bluez, IOBluetooth }:

qtModule {
  pname = "qtconnectivity";
  buildInputs = lib.optional stdenv.hostPlatform.isLinux bluez;
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    IOBluetooth
  ];
  outputs = [ "out" "dev" "bin" ];
}

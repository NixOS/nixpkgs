{ qtModule, lib, stdenv, qtbase, qtdeclarative, bluez, IOBluetooth }:

qtModule {
  pname = "qtconnectivity";
  buildInputs = lib.optional stdenv.isLinux bluez;
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ] ++ lib.optionals stdenv.isDarwin [
    IOBluetooth
  ];
  outputs = [ "out" "dev" "bin" ];
}

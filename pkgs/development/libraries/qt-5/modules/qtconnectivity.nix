{ qtModule, lib, stdenv, qtbase, qtdeclarative, bluez, IOBluetooth }:

qtModule {
  pname = "qtconnectivity";
  qtInputs = [ qtbase qtdeclarative ];
  buildInputs = lib.optional stdenv.isLinux bluez;
  propagatedBuildInputs = lib.optionals stdenv.isDarwin [ IOBluetooth ];
  outputs = [ "out" "dev" "bin" ];
}

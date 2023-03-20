{ qtModule, lib, stdenv, qtbase, qtdeclarative, bluez }:

qtModule {
  pname = "qtconnectivity";
  qtInputs = [ qtbase qtdeclarative ];
  buildInputs = lib.optional stdenv.isLinux bluez;
  outputs = [ "out" "dev" "bin" ];
}

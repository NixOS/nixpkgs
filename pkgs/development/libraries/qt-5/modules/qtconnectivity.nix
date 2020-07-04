{ qtModule, stdenv, qtbase, qtdeclarative, bluez }:

qtModule {
  name = "qtconnectivity";
  qtInputs = [ qtbase qtdeclarative ];
  buildInputs = stdenv.lib.optional stdenv.isLinux bluez;
  outputs = [ "out" "dev" "bin" ];
}

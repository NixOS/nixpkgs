{ qtModule, stdenv, qtbase, qtdeclarative, bluez, cf-private }:

qtModule {
  name = "qtconnectivity";
  qtInputs = [ qtbase qtdeclarative ];
  buildInputs = if stdenv.isDarwin then [ cf-private ] else [ bluez ];
  outputs = [ "out" "dev" "bin" ];
}

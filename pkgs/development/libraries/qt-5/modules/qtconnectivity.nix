{ qtModule, qtbase, qtdeclarative, bluez }:

qtModule {
  name = "qtconnectivity";
  qtInputs = [ qtbase qtdeclarative ];
  buildInputs = [ bluez ];
  outputs = [ "out" "dev" "bin" ];
}

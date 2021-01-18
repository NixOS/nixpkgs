{ qtModule, qtbase, qtdeclarative, qtdoc }:

qtModule {
  name = "qtpim";
  qtInputs = [ qtbase qtdeclarative qtdoc ];
  outputs = [ "out" "dev" "bin" ];
}

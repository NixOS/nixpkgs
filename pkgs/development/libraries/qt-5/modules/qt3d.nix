{ qtModule, qtbase, qtdeclarative }:

qtModule {
  name = "qt3d";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
}

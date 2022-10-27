{ qtModule, qtbase, qtdeclarative }:

qtModule {
  pname = "qt3d";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
}

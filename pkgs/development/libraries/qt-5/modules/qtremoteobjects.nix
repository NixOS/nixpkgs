{ qtModule, qtbase, qtdeclarative }:

qtModule {
  pname = "qtremoteobjects";
  qtInputs = [ qtbase qtdeclarative ];
  # cycle is detected in build when adding "dev" "bin" too
  outputs = [ "out" ];
}

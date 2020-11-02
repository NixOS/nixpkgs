{ qtModule, qtbase, qtdeclarative }:

qtModule {
  name = "qtremoteobjects";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" ];
}

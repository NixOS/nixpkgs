{ qtModule, qtbase, qtdeclarative }:

qtModule {
  name = "qtfeedback";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
}

{ qtModule, qtbase, qtdeclarative }:

qtModule {
  name = "qtsensors";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
}

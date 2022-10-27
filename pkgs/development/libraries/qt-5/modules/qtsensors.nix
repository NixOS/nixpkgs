{ qtModule, qtbase, qtdeclarative }:

qtModule {
  pname = "qtsensors";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
}

{ qtModule, qtbase, qtdeclarative }:

qtModule {
  name = "qtcharts";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
}

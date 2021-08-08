{ qtModule, qtbase, qtdeclarative }:

qtModule {
  pname = "qtcharts";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
}

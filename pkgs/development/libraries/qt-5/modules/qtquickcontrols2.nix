{ qtModule, qtdeclarative }:

qtModule {
  name = "qtquickcontrols2";
  qtInputs = [ qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
}

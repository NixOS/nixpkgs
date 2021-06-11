{ qtModule, qtdeclarative }:

qtModule {
  pname = "qtquickcontrols2";
  qtInputs = [ qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
}

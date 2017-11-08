{ qtModule, qtbase, qtdeclarative }:

qtModule {
  name = "qtwebsockets";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
}

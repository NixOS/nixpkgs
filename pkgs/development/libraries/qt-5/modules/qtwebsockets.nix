{ qtModule, qtbase, qtdeclarative }:

qtModule {
  pname = "qtwebsockets";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
}

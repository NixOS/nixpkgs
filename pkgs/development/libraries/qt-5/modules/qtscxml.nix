{ qtModule, qtbase, qtdeclarative }:

qtModule {
  pname = "qtscxml";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
}

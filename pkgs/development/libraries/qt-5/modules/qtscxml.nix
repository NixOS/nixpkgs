{ qtModule, qtbase, qtdeclarative }:

qtModule {
  name = "qtscxml";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
}

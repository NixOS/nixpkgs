{ qtModule, qtbase, qtdeclarative }:

qtModule {
  pname = "qtscxml";
  qtInputs = [ qtbase qtdeclarative ];
}

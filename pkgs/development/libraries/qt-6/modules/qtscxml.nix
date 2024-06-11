{ qtModule, qtbase, qtdeclarative }:

qtModule {
  pname = "qtscxml";
  propagatedBuildInputs = [ qtbase qtdeclarative ];
}

{ qtModule, qtbase, qtdeclarative }:

qtModule {
  pname = "qtxmlpatterns";
  qtInputs = [ qtbase qtdeclarative ];
  devTools = [ "bin/xmlpatterns" "bin/xmlpatternsvalidator" ];
}

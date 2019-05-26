{ qtModule, qtbase, qtdeclarative }:

qtModule {
  name = "qtxmlpatterns";
  qtInputs = [ qtbase qtdeclarative ];
  devTools = [ "bin/xmlpatterns" "bin/xmlpatternsvalidator" ];
}

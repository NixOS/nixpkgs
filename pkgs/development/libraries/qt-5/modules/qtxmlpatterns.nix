{ qtModule, qtbase }:

qtModule {
  name = "qtxmlpatterns";
  qtInputs = [ qtbase ];
  devTools = [ "bin/xmlpatterns" "bin/xmlpatternsvalidator" ];
}

{
  qtModule,
  qtbase,
  qtdeclarative,
}:

qtModule {
  pname = "qtxmlpatterns";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
  devTools = [
    "bin/xmlpatterns"
    "bin/xmlpatternsvalidator"
  ];
}

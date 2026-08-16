{
  qtModule,
  qtbase,
  qtdeclarative,
}:

qtModule {
  pname = "qtdatavis3d";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
}

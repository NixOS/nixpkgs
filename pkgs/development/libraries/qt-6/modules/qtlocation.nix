{
  qtModule,
  qtbase,
  qtdeclarative,
  qtpositioning,
}:

qtModule {
  pname = "qtlocation";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtpositioning
  ];
}

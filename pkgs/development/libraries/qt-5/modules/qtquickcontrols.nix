{
  qtModule,
  qtbase,
  qtdeclarative,
}:

qtModule {
  pname = "qtquickcontrols";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
}

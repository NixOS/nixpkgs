{
  qtModule,
  qtbase,
  qtdeclarative,
}:

qtModule {
  pname = "qtremoteobjects";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
}

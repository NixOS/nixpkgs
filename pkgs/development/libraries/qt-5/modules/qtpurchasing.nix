{
  qtModule,
  qtbase,
  qtdeclarative,
}:

qtModule {
  pname = "qtpurchasing";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
}

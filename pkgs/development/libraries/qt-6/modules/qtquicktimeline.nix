{
  qtModule,
  qtbase,
  qtdeclarative,
}:

qtModule {
  pname = "qtquicktimeline";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
}

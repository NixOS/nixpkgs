{
  qtModule,
  qtbase,
  qtdeclarative,
}:

qtModule {
  pname = "qtscxml";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
  outputs = [
    "out"
    "dev"
    "bin"
  ];
}

{
  qtModule,
  qtbase,
  qtdeclarative,
}:

qtModule {
  pname = "qtdoc";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
  outputs = [ "out" ];
}

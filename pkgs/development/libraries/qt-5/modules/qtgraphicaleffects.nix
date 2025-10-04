{
  qtModule,
  qtbase,
  qtdeclarative,
}:

qtModule {
  pname = "qtgraphicaleffects";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
  outputs = [
    "out"
    "dev"
  ];
}

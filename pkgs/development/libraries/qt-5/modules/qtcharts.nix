{
  qtModule,
  qtbase,
  qtdeclarative,
}:

qtModule {
  pname = "qtcharts";
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

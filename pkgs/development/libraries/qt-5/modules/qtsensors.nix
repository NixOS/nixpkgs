{
  qtModule,
  qtbase,
  qtdeclarative,
}:

qtModule {
  pname = "qtsensors";
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

{
  qtModule,
  qtbase,
  qtdeclarative,
}:

qtModule {
  pname = "qtquickcontrols2";
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

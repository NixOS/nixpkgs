{
  qtModule,
  qtbase,
  qtdeclarative,
  pkg-config,
}:

qtModule {
  pname = "qtgamepad";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
  nativeBuildInputs = [ pkg-config ];
  outputs = [
    "out"
    "dev"
    "bin"
  ];
}

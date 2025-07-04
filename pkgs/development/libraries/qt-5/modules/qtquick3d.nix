{
  qtModule,
  qtbase,
  qtdeclarative,
  openssl,
}:

qtModule {
  pname = "qtquick3d";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
  buildInputs = [ openssl ];
}

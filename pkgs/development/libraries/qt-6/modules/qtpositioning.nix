{
  qtModule,
  qtbase,
  qtdeclarative,
  qtserialport,
  openssl,
}:

qtModule {
  pname = "qtpositioning";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtserialport
  ];
  buildInputs = [ openssl ];
}

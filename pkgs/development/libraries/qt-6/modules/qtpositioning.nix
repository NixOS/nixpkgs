{
  qtModule,
  qtbase,
  qtdeclarative,
  qtserialport,
  pkg-config,
  openssl,
}:

qtModule {
  pname = "qtpositioning";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtserialport
  ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];
}

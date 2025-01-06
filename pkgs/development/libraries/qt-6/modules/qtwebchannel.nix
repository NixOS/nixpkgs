{
  qtModule,
  qtbase,
  qtdeclarative,
  qtwebsockets,
  openssl,
}:

qtModule {
  pname = "qtwebchannel";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtwebsockets
  ];
  buildInputs = [ openssl ];
}

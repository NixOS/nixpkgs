{ qtModule
, qtbase
, qtdeclarative
, qtwebsockets
, openssl
}:

qtModule {
  pname = "qtwebchannel";
  qtInputs = [ qtbase qtdeclarative qtwebsockets ];
  buildInputs = [ openssl ];
}

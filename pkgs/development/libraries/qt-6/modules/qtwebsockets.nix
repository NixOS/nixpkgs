{ qtModule
, qtbase
, qtdeclarative
, openssl
}:

qtModule {
  pname = "qtwebsockets";
  qtInputs = [ qtbase qtdeclarative ];
  buildInputs = [ openssl ];
}

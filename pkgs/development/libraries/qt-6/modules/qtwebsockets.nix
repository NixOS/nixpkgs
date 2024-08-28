{ qtModule
, qtbase
, qtdeclarative
, openssl
}:

qtModule {
  pname = "qtwebsockets";
  propagatedBuildInputs = [ qtbase qtdeclarative ];
  buildInputs = [ openssl ];
}

{ qtModule
, qtbase
, qtdeclarative
, openssl
}:

qtModule {
  pname = "qtwebsockets";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" ];
  buildInputs = [ openssl ];
}

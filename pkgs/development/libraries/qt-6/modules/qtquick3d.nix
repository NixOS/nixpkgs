{ qtModule
, qtbase
, qtdeclarative
, openssl
}:

qtModule {
  pname = "qtquick3d";
  qtInputs = [ qtbase qtdeclarative ];
  buildInputs = [ openssl ];
}

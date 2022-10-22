{ qtModule
, qtbase
, qtdeclarative
, libiconv
, icu
, openssl
}:

qtModule {
  pname = "qt5compat";
  qtInputs = [ qtbase qtdeclarative ];
  buildInputs = [ libiconv icu openssl openssl ];
}

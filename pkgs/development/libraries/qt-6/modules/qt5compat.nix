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
<<<<<<< HEAD
  buildInputs = [ libiconv icu openssl ];
=======
  buildInputs = [ libiconv icu openssl openssl ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}

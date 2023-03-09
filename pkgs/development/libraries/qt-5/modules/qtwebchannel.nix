{ lib
, stdenv
, qtModule
, qtbase
, qtdeclarative
}:

qtModule {
  pname = "qtwebchannel";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" ] ++ lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [ "bin" ];
}


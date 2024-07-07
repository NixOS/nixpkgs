{ lib
, stdenv
, qtModule
, qtbase
, qtdeclarative
}:

qtModule {
  pname = "qtwebchannel";
  propagatedBuildInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" ] ++ lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [ "bin" ];
}

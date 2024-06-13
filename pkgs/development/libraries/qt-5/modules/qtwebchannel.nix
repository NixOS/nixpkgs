{ lib
, stdenv
, qtModule
, qtbase
, qtdeclarative
}:

qtModule {
  pname = "qtwebchannel";
  propagatedBuildInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" ] ++ lib.optionals (lib.systems.equals stdenv.hostPlatform stdenv.buildPlatform) [ "bin" ];
}

{ lib
, stdenv
, qtModule
, qtbase
, qtdeclarative
, openssl
, pkgsBuildHost
}:

qtModule {
  pname = "qtwebsockets";
  propagatedBuildInputs = [ qtbase qtdeclarative ];
  buildInputs = [ openssl ];
  nativeQtBuildInputs = [ "qtdeclarative" ];
}


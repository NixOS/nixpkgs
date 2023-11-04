{ lib
, stdenv
, qtModule
, qtbase
, qtdeclarative
, qtserialport
, pkg-config
, openssl
, pkgsBuildHost
}:

qtModule {
  pname = "qtpositioning";
  propagatedBuildInputs = [ qtbase qtserialport ];
  nativeBuildInputs = [ qtbase.dev pkg-config ];
  buildInputs = [ openssl qtdeclarative ];
  nativeQtBuildInputs = [ "qtdeclarative" ];
}


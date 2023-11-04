{ lib
, stdenv
, qtModule
, qtbase
, qtdeclarative
, qtshadertools
, openssl
, pkgsBuildHost
}:

qtModule {
  pname = "qtquick3d";
  propagatedBuildInputs = [ qtbase ];
  nativeBuildInputs = [ qtshadertools ];
  nativeQtBuildInputs = [ "qtdeclarative" ];
  buildInputs = [ openssl qtdeclarative ];
  dontIgnorePath = true;
}


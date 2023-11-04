{ lib
, stdenv
, qtModule
, qtbase
, qtdeclarative
, pkgsBuildHost
}:

qtModule {
  pname = "qtquicktimeline";
  propagatedBuildInputs = [ qtbase qtdeclarative ];
  nativeQtBuildInputs = [ "qtdeclarative" ];
}


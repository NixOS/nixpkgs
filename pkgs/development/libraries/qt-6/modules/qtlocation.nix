{ lib
, stdenv
, qtModule
, qtbase
, qtdeclarative
, qtpositioning
, pkgsBuildHost
}:

qtModule {
  pname = "qtlocation";
  propagatedBuildInputs = [ qtbase qtdeclarative qtpositioning ];
  nativeQtBuildInputs = [ "qtpositioning" "qtdeclarative" ];
}

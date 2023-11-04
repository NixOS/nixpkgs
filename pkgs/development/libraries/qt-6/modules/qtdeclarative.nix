{ lib
, stdenv
, qtModule
, qtbase
, qtlanguageserver
, qtshadertools
, qtdeclarative
, openssl
, python3
, buildPackages
, pkgsBuildBuild
, pkgsBuildHost
, pkgsBuildTarget
}:

qtModule {
  pname = "qtdeclarative";
  buildInputs = [
    openssl
    python3
    qtbase
  ];
  nativeBuildInputs = [
    python3
    qtbase
    qtshadertools
  ];
  nativeQtBuildInputs = [ "qtdeclarative" ];
  patches = [
    # prevent headaches from stale qmlcache data
    ../patches/qtdeclarative-default-disable-qmlcache.patch
  ];
}

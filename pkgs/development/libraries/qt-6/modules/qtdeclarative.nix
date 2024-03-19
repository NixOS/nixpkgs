{ qtModule
, qtbase
, qtlanguageserver
, qtshadertools
, openssl
, stdenv
, python3
, lib
, pkgsBuildBuild
}:

qtModule {
  pname = "qtdeclarative";
  propagatedBuildInputs = [ qtbase qtlanguageserver qtshadertools openssl ];
  nativeBuildInputs = [ python3 ];
  patches = [
    # prevent headaches from stale qmlcache data
    ../patches/qtdeclarative-default-disable-qmlcache.patch
    # add version specific QML import path
    ../patches/qtdeclarative-qml-paths.patch
  ];
  cmakeFlags = lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DQt6ShaderToolsTools_DIR=${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderTools"
    "-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
  ];
}

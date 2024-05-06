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
  strictDeps = !stdenv.isDarwin; # fails to detect python3 otherwise
  propagatedBuildInputs = [ qtbase qtlanguageserver qtshadertools openssl ];
  nativeBuildInputs = [ python3 ];
  patches = [
    # prevent headaches from stale qmlcache data
    ../patches/0001-qtdeclarative-disable-qml-disk-cache.patch
    # add version specific QML import path
    ../patches/0002-qtdeclarative-also-use-versioned-qml-paths.patch
  ];
  cmakeFlags = [
    "-DQt6ShaderToolsTools_DIR=${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderTools"
  ]
  # Conditional is required to prevent infinite recursion during a cross build
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
  ];
}

{
  qtModule,
  qtbase,
  qtdeclarative,
  lib,
  pkgsBuildBuild,
  stdenv,
}:

qtModule {
  pname = "qtscxml";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];

  cmakeFlags = lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
    "-DQt6ScxmlTools_DIR=${pkgsBuildBuild.qt6.qtscxml}/lib/cmake/Qt6ScxmlTools"
  ];
}

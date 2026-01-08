{
  qtModule,
  qtbase,
  qtdeclarative,
  qtquick3d,
  qtquicktimeline,
  lib,
  pkgsBuildBuild,
  stdenv,
}:

qtModule {
  pname = "qtgraphs";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtquick3d
    qtquicktimeline
  ];

  # QtQuick component discovery expects Qt6Quick to be findable, and Qt6Quick depends on
  # the build-machine Qt6QuickTools package in cross builds.
  cmakeFlags = [
    "-DQt6Quick_DIR=${qtdeclarative}/lib/cmake/Qt6Quick"
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
  ];
}

{
  qtModule,
  qtbase,
  qtdeclarative,
  qtpositioning,
  lib,
  pkgsBuildBuild,
  stdenv,
}:

qtModule {
  pname = "qtlocation";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtpositioning
  ];

  # Qt6Qml (from qtdeclarative) requires the build-machine Qt6QmlTools package in cross builds.
  # qtlocation disables itself when Qt::Qml isn't available, which leaves no `install` target.
  cmakeFlags = [
    "-DQt6Quick_DIR=${qtdeclarative}/lib/cmake/Qt6Quick"
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
  ];

}

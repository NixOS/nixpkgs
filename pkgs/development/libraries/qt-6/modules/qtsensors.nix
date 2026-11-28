{
  qtModule,
  qtbase,
  qtdeclarative,
  qtsvg,
  pkgsBuildBuild,
}:

qtModule {
  pname = "qtsensors";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtsvg
  ];

  buildInputs = [
    # sensorfw # not available in nixpkgs
  ];

  cmakeFlags = [
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
    "-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
  ];

}

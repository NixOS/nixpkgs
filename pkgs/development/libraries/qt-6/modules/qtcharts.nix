{
  qtModule,
  qtbase,
  qtdeclarative,
  qtmultimedia,
  pkgsBuildBuild,
}:

qtModule {
  pname = "qtcharts";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtmultimedia
  ];

  cmakeFlags = [
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
    "-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
  ];
}

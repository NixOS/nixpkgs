{
  qtModule,
  qtbase,
  qtdeclarative,
  pkgsBuildBuild,
}:

qtModule {
  pname = "qtdatavis3d";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];

  cmakeFlags = [
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
  ];
}

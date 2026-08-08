{
  qtModule,
  qtbase,
  qtdeclarative,
  qtpositioning,
  pkgsBuildBuild,
}:

qtModule {
  pname = "qtlocation";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtpositioning
  ];

  cmakeFlags = [
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
    "-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
    "-DQt6ShaderToolsTools_DIR=${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderToolsTools"
  ];
}

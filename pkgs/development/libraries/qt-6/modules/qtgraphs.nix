{
  qtModule,
  qtbase,
  qtdeclarative,
  qtquick3d,
  qtquicktimeline,
  pkgsBuildBuild,
}:

qtModule {
  pname = "qtgraphs";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtquick3d
    qtquicktimeline
  ];

  cmakeFlags = [
    "-DQt6ShaderToolsTools_DIR=${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderToolsTools"
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
    "-DQt6Quick3DTools_DIR=${pkgsBuildBuild.qt6.qtquick3d}/lib/cmake/Qt6Quick3DTools"
  ];
}

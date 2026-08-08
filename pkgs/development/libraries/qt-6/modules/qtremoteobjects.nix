{
  lib,
  stdenv,
  qtModule,
  qtbase,
  qtdeclarative,
  pkgsBuildBuild,
}:

qtModule {
  pname = "qtremoteobjects";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];

  cmakeFlags = [
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
  ]
  # Conditional is required to prevent infinite recursion during a cross build
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DQt6RemoteObjectsTools_DIR=${pkgsBuildBuild.qt6.qtremoteobjects}/lib/cmake/Qt6RemoteObjectsTools"
  ];
}

{
  lib,
  stdenv,
  qtModule,
  qtbase,
  qtconnectivity,
  qtdeclarative,
  qtwebsockets,
  pkgsBuildBuild,
}:

qtModule {
  pname = "qtremoteobjects";
  propagatedBuildInputs = [
    qtbase
    qtconnectivity
    qtdeclarative
    qtwebsockets
  ];

  # Conditional is required to prevent infinite recursion during a cross build
  cmakeFlags =
    lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
      "-DQt6RemoteObjectsTools_DIR=${pkgsBuildBuild.qt6.qtremoteobjects}/lib/cmake/Qt6RemoteObjectsTools"
    ]
    ++ [
      "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
    ];
}

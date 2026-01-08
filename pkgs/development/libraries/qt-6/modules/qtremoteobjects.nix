{
  qtModule,
  qtbase,
  qtdeclarative,
  qtconnectivity,
  qtwebsockets,
  lib,
  pkgsBuildBuild,
  stdenv,
}:

qtModule {
  pname = "qtremoteobjects";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtconnectivity
    qtwebsockets
  ];

  cmakeFlags = lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DQt6RemoteObjectsTools_DIR=${pkgsBuildBuild.qt6.qtremoteobjects}/lib/cmake/Qt6RemoteObjectsTools"
  ];
}

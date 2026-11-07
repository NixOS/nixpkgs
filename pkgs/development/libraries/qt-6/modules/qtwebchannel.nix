{
  lib,
  stdenv,
  pkgsBuildBuild,
  qtModule,
  qtbase,
  qtdeclarative,
  qtwebsockets,
  openssl,
}:

qtModule {
  pname = "qtwebchannel";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtwebsockets
  ];
  buildInputs = [ openssl ];
  cmakeFlags = lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
  ];
}

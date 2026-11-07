{
  lib,
  stdenv,
  pkgsBuildBuild,
  qtModule,
  qtbase,
  qtdeclarative,
  qtserialport,
  pkg-config,
  openssl,
}:

qtModule {
  pname = "qtpositioning";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtserialport
  ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];
  cmakeFlags = lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
  ];
}

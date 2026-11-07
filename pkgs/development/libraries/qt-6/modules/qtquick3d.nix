{
  lib,
  stdenv,
  pkgsBuildBuild,
  qtModule,
  qtbase,
  qtdeclarative,
  openssl,
}:

qtModule {
  pname = "qtquick3d";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
  buildInputs = [ openssl ];
  cmakeFlags = lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
    "-DQt6ShaderToolsTools_DIR=${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderToolsTools"
    "-DQt6Quick3DTools_DIR=${pkgsBuildBuild.qt6.qtquick3d}/lib/cmake/Qt6Quick3DTools"
  ];
}

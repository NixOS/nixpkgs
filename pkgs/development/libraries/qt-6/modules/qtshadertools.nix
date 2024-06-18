{ qtModule
, qtbase
, stdenv
, lib
, pkgsBuildBuild
}:

qtModule {
  pname = "qtshadertools";
  propagatedBuildInputs = [ qtbase ];
  cmakeFlags = lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DQt6ShaderToolsTools_DIR=${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderToolsTools"
  ];
  meta.mainProgram = "qsb";
}

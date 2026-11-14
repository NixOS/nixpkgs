{
  qtModule,
  lib,
  stdenv,
  pkgsBuildBuild,
  qtbase,
  qtmultimedia,
  pkg-config,
  flite,
  alsa-lib,
  speechd-minimal,
}:

qtModule {
  pname = "qtspeech";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    flite
    alsa-lib
    speechd-minimal
  ];
  propagatedBuildInputs = [
    qtbase
    qtmultimedia
  ];
  cmakeFlags = lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
  ];
}

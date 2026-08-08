{
  qtModule,
  lib,
  stdenv,
  qtbase,
  qtmultimedia,
  flite,
  alsa-lib,
  speechd-minimal,
  pkgsBuildBuild,
}:

qtModule {
  pname = "qtspeech";
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    flite
    alsa-lib
    speechd-minimal
  ];
  propagatedBuildInputs = [
    qtbase
    qtmultimedia
  ];

  cmakeFlags = [
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
    "-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
  ];
}

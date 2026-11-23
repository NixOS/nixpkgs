{
  qtModule,
  lib,
  stdenv,
  qtbase,
  qtmultimedia,
  flite,
  alsa-lib,
  speechd-minimal,
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
}

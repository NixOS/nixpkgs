{
  stdenv,
  lib,
  fetchgit,
  cmake,
  pkg-config,
  alsa-lib,
  fftw,
  flac,
  lame,
  libjack2,
  libmad,
  libpulseaudio,
  libsamplerate,
  libsndfile,
  libvorbis,
  portaudio,
  qt6,
  wavpack,
}:
stdenv.mkDerivation {
  pname = "traverso";
  version = "0-unstable-2024-09-28";

  src = fetchgit {
    url = "https://git.savannah.nongnu.org/git/traverso.git";
    rev = "f34717623a8d19dd7c04d9604ef4468734140abc";
    hash = "sha256-eobQFJohndwQjXRXBAehkTWS9jR/1bQOjrOF1XJN5L4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    alsa-lib
    fftw
    flac.dev
    libjack2
    lame
    libmad
    libpulseaudio
    libsamplerate.dev
    libsndfile.dev
    libvorbis
    portaudio
    qt6.qtbase
    wavpack
  ];

  cmakeFlags = [
    "-DWANT_PORTAUDIO=1"
    "-DWANT_PULSEAUDIO=1"
    "-DWANT_MP3_ENCODE=1"
    "-DWANT_LV2=0"
  ];

  meta = {
    description = "Cross-platform multitrack audio recording and audio editing suite";
    mainProgram = "traverso";
    homepage = "https://savannah.nongnu.org/projects/traverso";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
    ];
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isAarch64;
    maintainers = with lib.maintainers; [ coconnor ];
  };
}

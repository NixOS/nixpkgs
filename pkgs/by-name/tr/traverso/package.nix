{
  stdenv,
  lib,
  fetchurl,
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
  wavpack,
  libsForQt5,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "traverso";
  version = "0.49.6";

  src = fetchurl {
    url = "https://traverso-daw.org/traverso-${finalAttrs.version}.tar.gz";
    sha256 = "12f7x8kw4fw1j0xkwjrp54cy4cv1ql0zwz2ba5arclk4pf6bhl7q";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
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
    libsForQt5.qtbase
    wavpack
  ];

  cmakeFlags = [
    "-DWANT_PORTAUDIO=1"
    "-DWANT_PULSEAUDIO=1"
    "-DWANT_MP3_ENCODE=1"
    "-DWANT_LV2=0"
  ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "Cross-platform multitrack audio recording and audio editing suite";
    mainProgram = "traverso";
    homepage = "https://traverso-daw.org/";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
    ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ coconnor ];
  };
})

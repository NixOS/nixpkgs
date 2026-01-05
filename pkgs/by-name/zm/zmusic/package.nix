{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  cmake,
  fluidsynth,
  libsndfile,
  mpg123,
  ninja,
  pkg-config,
  soundfont-fluid,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "zmusic";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "ZDoom";
    repo = "ZMusic";
    rev = version;
    hash = "sha256-Lg0DN5p2xDB4j+kxa/TxM27rC+GPMK8kaPLajNDMvBg=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [ ./fluidsynth.patch ];

  postPatch = ''
    substituteInPlace source/mididevices/music_fluidsynth_mididevice.cpp \
      --replace-fail "/usr/share/sounds/sf2" "${soundfont-fluid}/share/soundfonts" \
      --replace-fail "FluidR3_GM.sf2" "FluidR3_GM2-2.sf2"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    fluidsynth
    libsndfile
    mpg123
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ];

  meta = {
    description = "GZDoom's music system as a standalone library";
    homepage = "https://github.com/ZDoom/ZMusic";
    license = with lib.licenses; [
      free
      gpl3Plus
      lgpl21Plus
      lgpl3Plus
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      azahi
      lassulus
      Gliczy
      r4v3n6101
    ];
  };
}

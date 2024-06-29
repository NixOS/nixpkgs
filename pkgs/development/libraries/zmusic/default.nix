{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, alsa-lib
, cmake
, fluidsynth
, libsndfile
, mpg123
, ninja
, pkg-config
, soundfont-fluid
, zlib
}:

stdenv.mkDerivation rec {
  pname = "zmusic";
  version = "1.1.12";

  src = fetchFromGitHub {
    owner = "ZDoom";
    repo = "ZMusic";
    rev = version;
    hash = "sha256-waxgn4Dg8One2Hv7J2efMoYo5mmaMSMiPQSNq57kbvE=";
  };

  outputs = [ "out" "dev" ];

  patches = [
    (fetchpatch {
      name = "system-fluidsynth.patch";
      url = "https://git.alpinelinux.org/aports/plain/testing/zmusic/system-fluidsynth.patch?id=59bac94da374cb01bc2a0e49d9e9287812fa1ac0";
      hash = "sha256-xKaqiNk1Kt9yNLB22IVmSEtGeOtxrCi7YtFCmhNr0MI=";
    })
  ];

  postPatch = ''
    substituteInPlace source/mididevices/music_fluidsynth_mididevice.cpp \
      --replace "/usr/share/sounds/sf2" "${soundfont-fluid}/share/soundfonts" \
      --replace "FluidR3_GM.sf2" "FluidR3_GM2-2.sf2"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    fluidsynth
    libsndfile
    mpg123
    zlib
  ];

  meta = with lib; {
    description = "GZDoom's music system as a standalone library";
    homepage = "https://github.com/ZDoom/ZMusic";
    license = with licenses; [
      free
      gpl3Plus
      lgpl21Plus
      lgpl3Plus
    ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ azahi lassulus ];
  };
}

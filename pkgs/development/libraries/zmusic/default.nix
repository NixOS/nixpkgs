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
  version = "1.1.13";

  src = fetchFromGitHub {
    owner = "ZDoom";
    repo = "ZMusic";
    rev = version;
    hash = "sha256-rvvMS5KciHEvoY4hSfgAEyWJiDMqBto4o09oIpQIGTQ=";
  };

  outputs = [ "out" "dev" ];

  patches = [
    (fetchpatch {
      name = "system-fluidsynth.patch";
      url = "https://git.alpinelinux.org/aports/plain/community/zmusic/system-fluidsynth.patch?id=ca353107ef4f2e5c55c3cc824b0840e2838fb894";
      hash = "sha256-xKaqiNk1Kt9yNLB22IVmSEtGeOtxrCi7YtFCmhNr0MI=";
    })
  ];

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
    platforms = platforms.unix;
    maintainers = with maintainers; [ azahi lassulus ];
  };
}

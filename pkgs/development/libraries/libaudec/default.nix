{
  lib,
  stdenv,
  fetchFromGitHub,
  libsndfile,
  libsamplerate,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "libaudec";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "zrythm";
    repo = "libaudec";
    rev = "v${version}";
    sha256 = "sha256-8morbrq8zG+2N3ruMeJa85ci9P0wPQOfZ5H56diFEAo=";
  };

  buildInputs = [
    libsndfile
    libsamplerate
  ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  meta = with lib; {
    description = "A library for reading and resampling audio files";
    homepage = "https://www.zrythm.org";
    license = licenses.agpl3Plus;
    mainProgram = "audec";
    platforms = platforms.all;
  };
}

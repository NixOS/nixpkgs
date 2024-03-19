{ lib, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, libpng
, zlib
, giflib
, libjpeg
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "impy";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "bcampbell";
    repo = "impy";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-0bHm3jawYgcIeF2COALWlypX7kvPw1hifB/W+TKcC4M=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libpng
    zlib
    giflib
    libjpeg
  ];

  meta = with lib; {
    description = "A simple library for loading/saving images and animations, written in C";
    homepage = "https://github.com/bcampbell/impy";
    license = licenses.gpl3;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
})

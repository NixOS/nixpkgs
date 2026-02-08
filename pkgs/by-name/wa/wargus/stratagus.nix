{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  zlib,
  bzip2,
  libpng,
  libx11,
  lua5_1,
  toluapp,
  SDL2,
  SDL2_mixer,
  SDL2_image,
  libGL,
}:

stdenv.mkDerivation rec {
  pname = "stratagus";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "wargus";
    repo = "stratagus";
    rev = "v${version}";
    sha256 = "sha256-q8AvIWr/bOzI0wV0D2emxIXYEKDYmFxbtwr2BS+xYfA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    zlib
    bzip2
    libpng
    lua5_1
    toluapp
    (lib.getDev SDL2)
    SDL2_image
    SDL2_mixer
    libGL
    libx11
  ];
  cmakeFlags = [
    "-DCMAKE_CXX_FLAGS=-Wno-error=format-overflow"
  ];

  meta = {
    description = "Strategy game engine";
    homepage = "https://wargus.github.io/stratagus.html";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.astro ];
    platforms = lib.platforms.linux;
  };
}

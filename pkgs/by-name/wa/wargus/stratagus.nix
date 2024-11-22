{ lib, stdenv, fetchFromGitHub
, cmake, pkg-config, makeWrapper
, zlib, bzip2, libpng, lua5_1, toluapp
, SDL2, SDL2_mixer, SDL2_image, libGL
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

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    zlib bzip2 libpng
    lua5_1 toluapp
    (lib.getDev SDL2) SDL2_image SDL2_mixer libGL
  ];
  cmakeFlags = [
    "-DCMAKE_CXX_FLAGS=-Wno-error=format-overflow"
  ];

  meta = with lib; {
    description = "strategy game engine";
    homepage = "https://wargus.github.io/stratagus.html";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.astro ];
    platforms = platforms.linux;
  };
}

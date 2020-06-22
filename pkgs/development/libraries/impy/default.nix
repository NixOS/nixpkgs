{ stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libpng
, zlib
, giflib
, libjpeg
, SDL2
}:

stdenv.mkDerivation rec {
  pname = "impy";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "bcampbell";
    repo = "impy";
    rev = "v${version}";
    sha256 = "1h45xjms56radhknspyx17a12dpnm7xgqm1x1chy42aw5ic8b5qf";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libpng
    zlib
    giflib
    libjpeg
    SDL2
  ];

  meta = with stdenv.lib; {
    description = "A simple library for loading/saving images and animations, written in C";
    homepage = "https://github.com/bcampbell/impy";
    license = licenses.gpl3;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}


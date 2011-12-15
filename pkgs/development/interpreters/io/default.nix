{ stdenv, fetchurl, cmake, zlib, sqlite, gmp, libffi, cairo, ncurses,
  freetype, mesa, libpng, libtiff, libjpeg, readline, libsndfile, libxml2,
  freeglut, libsamplerate, pcre, libevent, libedit, yajl,
  python, openssl, glfw
}:

stdenv.mkDerivation {
  name = "io-2011.09.12";
  src = fetchurl {
    url = http://github.com/stevedekorte/io/tarball/2011.09.12;
    name = "io-2011.09.12.tar.gz";
    sha256 = "14nhk5vkk74pbf36jsfaxqh2ihi5d7jby79yf1ibbax319xbjk3v";
  };

  buildInputs = [
    cmake zlib sqlite gmp libffi cairo ncurses freetype mesa
    libpng libtiff libjpeg readline libsndfile libxml2
    freeglut libsamplerate pcre libevent libedit yajl
  ];

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=release" ];

  meta = {
    description = "Io programming language";
    maintainers = with stdenv.lib.maintainers; [
      raskin
      z77z
    ];
    platforms = stdenv.lib.platforms.linux;
  };
}

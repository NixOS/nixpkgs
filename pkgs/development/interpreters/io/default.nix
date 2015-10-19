{ stdenv, fetchurl, cmake, zlib, sqlite, gmp, libffi, cairo, ncurses,
  freetype, mesa, libpng, libtiff, libjpeg, readline, libsndfile, libxml2,
  freeglut, libsamplerate, pcre, libevent, libedit, yajl,
  python, libssl, glfw
}:

stdenv.mkDerivation {
  name = "io-2013.12.04";
  src = fetchurl {
    url = http://github.com/stevedekorte/io/tarball/2013.12.04;
    name = "io-2013.12.04.tar.gz";
    sha256 = "0kvwr32xdpcr32rnv301xr5l89185dsisbj4v465m68isas0gjm5";
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

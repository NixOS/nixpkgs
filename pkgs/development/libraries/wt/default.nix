{stdenv, fetchFromGitHub, cmake, boost, pkgconfig, doxygen, qt48Full, libharu, 
  pango, fcgi, firebird, libmysql, postgresql, graphicsmagick, glew, openssl,
  pcre }:

stdenv.mkDerivation rec {
  name = "wt";
  version = "3.3.6";

  src = fetchFromGitHub {
    owner = "kdeforche";
    repo = name;
    rev = version;
    sha256 = "1pvykc969l9cpd0da8bgpi4gr8f6qczrbpprrxamyj1pn0ydzvq3";
  };

  enableParallelBuilding = true;

  buildInputs = [ cmake boost pkgconfig doxygen qt48Full libharu 
    pango fcgi firebird libmysql postgresql graphicsmagick glew 
    openssl pcre ];

  cmakeFlags = [
    "-DWT_WRASTERIMAGE_IMPLEMENTATION=GraphicsMagick"
    "-DWT_CPP_11_MODE=-std=c++11"
    "-DGM_PREFIX=${graphicsmagick}"
    "-DMYSQL_PREFIX=${libmysql.dev}"
    "--no-warn-unused-cli"
  ];

  patches = [ ./cmake.patch ];  # fix a cmake warning; PR sent to upstream 

  meta = with stdenv.lib; {
    homepage = "https://www.webtoolkit.eu/wt";
    description = "C++ library for developing web applications";
    platforms = platforms.linux ;
    license = licenses.gpl2;
    maintainers = [ maintainers.juliendehos ];
  };
}


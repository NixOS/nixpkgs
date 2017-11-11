{ stdenv, fetchFromGitHub, cmake, boost, pkgconfig, doxygen, qt48Full, libharu
, pango, fcgi, firebird, libmysql, postgresql, graphicsmagick, glew, openssl
, pcre
}:

stdenv.mkDerivation rec {
  name = "wt-${version}";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "kdeforche";
    repo = "wt";
    rev = version;
    sha256 = "1451xxvnx6mlvxg0jxlr1mfv5v18h2214kijk5kacilqashfc43i";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    cmake boost doxygen qt48Full libharu
    pango fcgi firebird libmysql postgresql graphicsmagick glew
    openssl pcre
  ];

  cmakeFlags = [
    "-DWT_WRASTERIMAGE_IMPLEMENTATION=GraphicsMagick"
    "-DWT_CPP_11_MODE=-std=c++11"
    "-DGM_PREFIX=${graphicsmagick}"
    "-DMYSQL_PREFIX=${libmysql.dev}"
    "--no-warn-unused-cli"
  ];

  meta = with stdenv.lib; {
    homepage = https://www.webtoolkit.eu/wt;
    description = "C++ library for developing web applications";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = [ maintainers.juliendehos ];
  };
}


{ stdenv, fetchgit, doxygen, pkgconfig, cmake, qtbase, qtscript, qtquick1 }:

stdenv.mkDerivation rec {
  name = "libmarble-ssrf-${version}";
  version = "2016-11-09";

  src = fetchgit {
    sha256 = "1dm2hdk6y36ls7pxbzkqmyc46hdy2cd5f6pkxa6nfrbhvk5f31zd";
    url = "git://git.subsurface-divelog.org/marble";
    rev = "4325da93b7516abb6f93a1417adc10593dacd794";
  };

  buildInputs = [ qtbase qtscript qtquick1 ];
  nativeBuildInputs = [ doxygen pkgconfig cmake ];

  enableParallelBuilding = true;

  preConfigure = ''
    cmakeFlags="$cmakeFlags -DCMAKE_BUILD_TYPE=Release \
                            -DQTONLY=TRUE -DQT5BUILD=ON \
                            -DBUILD_MARBLE_TESTS=NO \
                            -DWITH_DESIGNER_PLUGIN=NO \
                            -DBUILD_MARBLE_APPS=NO"
  '';

  meta = with stdenv.lib; {
    description = "Qt library for a slippy map with patches from the Subsurface project";
    homepage = "http://subsurface-divelog.org";
    license = licenses.lgpl21;
    maintainers = [ maintainers.mguentner ];
    platforms = platforms.all;
  };
}

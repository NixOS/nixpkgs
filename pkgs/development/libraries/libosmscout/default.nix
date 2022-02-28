{ lib, mkDerivation, fetchgit, cmake, pkg-config
, marisa, qtlocation }:

mkDerivation rec {
  pname = "libosmscout";
  version = "2017.06.30";

  src = fetchgit {
    url = "git://git.code.sf.net/p/libosmscout/code";
    rev = "0c0fde4d9803539c99911389bc918377a93f350c";
    sha256 = "1pa459h52kw88mvsdvkz83f4p35vvgsfy2qfjwcj61gj4y9d2rq4";
  };

  cmakeFlags = [ "-DOSMSCOUT_BUILD_TESTS=OFF" ];

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ marisa qtlocation ];

  meta = with lib; {
    description = "Simple, high-level interfaces for offline location and POI lokup, rendering and routing functionalities based on OpenStreetMap (OSM) data";
    homepage = "http://libosmscout.sourceforge.net/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.Thra11 ];
    platforms = platforms.linux;
  };
}

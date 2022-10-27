{ lib, mkDerivation, fetchFromGitHub, cmake, pkg-config
, marisa, qttools, qtlocation }:

mkDerivation rec {
  pname = "libosmscout";
  version = "2022.04.25";

  src = fetchFromGitHub {
    owner = "Framstag";
    repo = "libosmscout";
    rev = "4c3b28472864b8e9cdda80a05ec73ef22cb39323";
    sha256 = "sha256-Qe5TkF4BwlsEI7emC0gdc7SmS4QrSGLiO0QdjuJA09g=";
  };

  cmakeFlags = [ "-DOSMSCOUT_BUILD_TESTS=OFF" ];

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ marisa qttools qtlocation ];

  meta = with lib; {
    description = "Simple, high-level interfaces for offline location and POI lokup, rendering and routing functionalities based on OpenStreetMap (OSM) data";
    homepage = "http://libosmscout.sourceforge.net/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.Thra11 ];
    platforms = platforms.linux;
  };
}

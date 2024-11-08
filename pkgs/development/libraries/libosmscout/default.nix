{ lib, mkDerivation, fetchFromGitHub, fetchpatch, cmake, pkg-config
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

  patches = [
    # Fix build with libxml v2.12
    # FIXME: Remove at next package update
    (fetchpatch {
      name = "libxml-2.12-fix.patch";
      url = "https://github.com/Framstag/libosmscout/commit/db7b307de1a1146a6868015a0adfc2e21b7d5e39.patch";
      hash = "sha256-5NDamzb2K18sMVfREnUNksgD2NL7ELzLl83SlGIveO0=";
    })
  ];

  cmakeFlags = [ "-DOSMSCOUT_BUILD_TESTS=OFF" ];

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ marisa qttools qtlocation ];

  meta = with lib; {
    description = "Simple, high-level interfaces for offline location and POI lokup, rendering and routing functionalities based on OpenStreetMap (OSM) data";
    homepage = "https://libosmscout.sourceforge.net/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.Thra11 ];
    platforms = platforms.linux;
  };
}

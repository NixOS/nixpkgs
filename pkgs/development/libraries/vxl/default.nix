{ lib, stdenv, fetchFromGitHub, unzip, cmake, libtiff, expat, zlib, libpng, libjpeg }:
stdenv.mkDerivation rec {
  pname = "vxl";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "vxl";
    repo = "vxl";
    rev = "v${version}";
    sha256 = "sha256-4kMpIrywEZzt0JH95LHeDLrDneii0R/Uw9GsWkvED+E=";
  };

  nativeBuildInputs = [ cmake unzip ];
  buildInputs = [ libtiff expat zlib libpng libjpeg ];

  meta = {
    description = "C++ Libraries for Computer Vision Research and Implementation";
    homepage = "https://vxl.sourceforge.net/";
    # license appears contradictory; see https://github.com/vxl/vxl/issues/752
    # (and see https://github.com/InsightSoftwareConsortium/ITK/pull/1920/files for potential patch)
    license = [ lib.licenses.unfree ];
    maintainers = with lib.maintainers; [viric];
    platforms = with lib.platforms; linux;
  };
}

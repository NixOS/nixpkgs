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
    license = "VXL License";
    maintainers = with lib.maintainers; [viric];
    platforms = with lib.platforms; linux;
  };
}

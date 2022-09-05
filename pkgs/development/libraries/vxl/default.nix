{ lib, stdenv, fetchFromGitHub, unzip, cmake, libtiff, expat, zlib, libpng, libjpeg }:
stdenv.mkDerivation rec {
  pname = "vxl";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "vxl";
    repo = "vxl";
    rev = "v${version}";
    sha256 = "0qmqrijl14xlsbd77jk9ygg44h3lqzpswia6yif1iia6smqccjsr";
  };

  nativeBuildInputs = [ cmake unzip ];
  buildInputs = [ libtiff expat zlib libpng libjpeg ];

  meta = {
    description = "C++ Libraries for Computer Vision Research and Implementation";
    homepage = "http://vxl.sourceforge.net/";
    license = "VXL License";
    maintainers = with lib.maintainers; [viric];
    platforms = with lib.platforms; linux;
  };
}

{ stdenv, fetchurl, unzip, cmake, libtiff, expat, zlib, libpng, libjpeg }:
stdenv.mkDerivation {
  name = "vxl-1.13.0";

  src = fetchurl {
    url = mirror://sourceforge/vxl/vxl-1.13.0.zip;
    sha256 = "05xk9dfkqsznp1dic8rcsdhgdp12bikwx1zpci0w3s20fs8q8nn1";
  };

  buildInputs = [ cmake unzip libtiff expat zlib libpng libjpeg ];

  # BUILD_OUL wants old linux headers for videodev.h, not available
  # in stdenv linux headers
  cmakeFlags = "-DBUILD_TESTING=OFF -DBUILD_OUL=OFF "
    + (if (stdenv.system == "x86_64-linux") then
      "-DCMAKE_CXX_FLAGS=-fPIC -DCMAKE_C_FLAGS=-fPIC"
    else
      "");

  enableParallelBuilding = true;

  meta = {
    description = "C++ Libraries for Computer Vision Research and Implementation";
    homepage = http://vxl.sourceforge.net/;
    license = "VXL License";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}

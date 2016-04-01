{ stdenv, fetchurl, unzip, cmake, libtiff, expat, zlib, libpng, libjpeg }:
stdenv.mkDerivation {
  name = "vxl-1.17.0";

  src = fetchurl {
    url = mirror://sourceforge/vxl/vxl-1.17.0.zip;
    sha256 = "1qg7i8h201pa8jljg7vph4rlxk6n5cj9f9gd1hkkmbw6fh44lsxh";
  };

  buildInputs = [ cmake unzip libtiff expat zlib libpng libjpeg ];

  # BUILD_OUL wants old linux headers for videodev.h, not available
  # in stdenv linux headers
  # BUILD_BRL fails to find open()
  cmakeFlags = "-DBUILD_TESTING=OFF -DBUILD_OUL=OFF -DBUILD_BRL=OFF -DBUILD_CONTRIB=OFF "
    + (if stdenv.system == "x86_64-linux" then
      "-DCMAKE_CXX_FLAGS=-fPIC -DCMAKE_C_FLAGS=-fPIC"
    else
      "");

  enableParallelBuilding = true;

  patches = [ ./gcc5.patch ];

  meta = {
    description = "C++ Libraries for Computer Vision Research and Implementation";
    homepage = http://vxl.sourceforge.net/;
    license = "VXL License";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}

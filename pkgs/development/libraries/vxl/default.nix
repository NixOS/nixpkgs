{ stdenv, fetchurl, unzip, cmake, libtiff, expat, zlib, libpng, libjpeg }:
stdenv.mkDerivation {
  name = "vxl-1.14.0";

  src = fetchurl {
    url = mirror://sourceforge/vxl/vxl-1.14.0.zip;
    sha256 = "0434wxvxyr9baq3q5rhjcqvlaq5p9n5ax400bdrc49ff2jddq0h2";
  };

  buildInputs = [ cmake unzip libtiff expat zlib libpng libjpeg ];

  cmakeFlags = if (stdenv.system == "x86_64-linux") then
      "-DCMAKE_CXX_FLAGS=-fPIC -DCMAKE_C_FLAGS=-fPIC"
    else
      "";

  meta = {
    description = "C++ Libraries for Computer Vision Research and Implementation";
    homepage = http://vxl.sourceforge.net/;
    license = "VXL License";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}

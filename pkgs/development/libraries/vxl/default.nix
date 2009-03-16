{ stdenv, fetchurl, unzip, cmake, libtiff, expat, zlib, libpng, libjpeg }:
stdenv.mkDerivation {
  name = "vxl-1.11.0";

  src = fetchurl {
    url = mirror://sourceforge/vxl/vxl-1.11.0.zip;
    sha256 = "84f38d0c3656b5e4470e16ddce715bafcaa478ff066e6cec6f54524b5d72fa68";
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
  };
}

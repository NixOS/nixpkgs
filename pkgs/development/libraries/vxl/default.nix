{ stdenv, fetchurl, unzip, cmake, libtiff, expat, zlib, libpng, libjpeg }:
stdenv.mkDerivation {
  name = "vxl-1.12.0";

  src = fetchurl {
    url = mirror://sourceforge/vxl/vxl-1.12.0.zip;
    sha256 = "11nwa37g42l81xv18s2q2jflc4vr2ncsm7wn7yv269wfwxcjhnlc";
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

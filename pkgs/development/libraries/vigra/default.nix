{ stdenv, fetchurl, cmake, libtiff, libpng, libjpeg, doxygen, python, fftw }:
stdenv.mkDerivation {
  name = "vigra-1.7.0";

  src = fetchurl {
    url = http://hci.iwr.uni-heidelberg.de/vigra/vigra-1.7.0-src.tar.gz;
    sha256 = "1laf9p0h35xpzs98yd13alm17gh40sn9b7z01ylcja4g7p3a3hs4";
  };

  buildInputs = [ cmake fftw libtiff libpng libjpeg doxygen python ];

  cmakeFlags = if (stdenv.system == "x86_64-linux") then
      "-DCMAKE_CXX_FLAGS=-fPIC -DCMAKE_C_FLAGS=-fPIC"
    else
      "";

  meta = {
    description = "Novel computer vision C++ library with customizable algorithms and data structures";
    homepage = http://hci.iwr.uni-heidelberg.de/vigra/;
    license = "MIT";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}

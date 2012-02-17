{ stdenv, fetchurl, cmake, libtiff, libpng, libjpeg, doxygen, python,
  fftw, fftwSinglePrec, hdf5, boost, numpy }:
stdenv.mkDerivation rec {
  name = "vigra-1.8.0";

  src = fetchurl {
    url = "${meta.homepage}/${name}-src.tar.gz";
    sha256 = "0542qy1bqaq73l7i8aqdhwdbhd6m1wldsn1w2sfyf8yf4398ffpw";
  };

  buildInputs = [ cmake fftw fftwSinglePrec libtiff libpng libjpeg python boost
    numpy hdf5 ];

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

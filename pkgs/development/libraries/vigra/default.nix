{ stdenv, fetchurl, cmake, libtiff, libpng, libjpeg, doxygen, python,
  fftw, fftwSinglePrec, hdf5, boost, numpy }:
stdenv.mkDerivation rec {
  name = "vigra-1.9.0";

  src = fetchurl {
    urls = [
      "${meta.homepage}/${name}-src.tar.gz"
      "${meta.homepage}-old-versions/${name}-src.tar.gz"
      ];
    sha256 = "00fg64da6dj9k42d90dz6y7x91xw1xqppcla14im74m4afswrgcg";
  };

  buildInputs = [ cmake fftw fftwSinglePrec libtiff libpng libjpeg python boost
    numpy hdf5 ];

  preConfigure = "cmakeFlags+=\" -DVIGRANUMPY_INSTALL_DIR=$out/lib/${python.libPrefix}/site-packages\"";
  cmakeFlags = stdenv.lib.optionals (stdenv.system == "x86_64-linux")
      [ "-DCMAKE_CXX_FLAGS=-fPIC" "-DCMAKE_C_FLAGS=-fPIC" ];

  meta = {
    description = "Novel computer vision C++ library with customizable algorithms and data structures";
    homepage = http://hci.iwr.uni-heidelberg.de/vigra;
    license = "MIT";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}

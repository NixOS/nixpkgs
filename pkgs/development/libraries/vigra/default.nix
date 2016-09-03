{ stdenv, fetchurl, boost, cmake, doxygen, fftw, fftwSinglePrec, hdf5, ilmbase
, libjpeg, libpng, libtiff, numpy, openexr, python }:

stdenv.mkDerivation rec {
  name = "vigra-${version}";
  version = "1.10.0";

  src = fetchurl {
    url = "https://github.com/ukoethe/vigra/archive/Version-${stdenv.lib.replaceChars ["."] ["-"] version}.tar.gz";
    sha256 = "1y3yii8wnyz68n0mzcmjylwd6jchqa3l913v39l2zsd2rv5nyvs0";
  };

  NIX_CFLAGS_COMPILE = "-I${ilmbase.dev}/include/OpenEXR";

  buildInputs = [ boost cmake fftw fftwSinglePrec hdf5 ilmbase libjpeg libpng
                  libtiff numpy openexr python ];

  preConfigure = "cmakeFlags+=\" -DVIGRANUMPY_INSTALL_DIR=$out/lib/${python.libPrefix}/site-packages\"";

  cmakeFlags = [ "-DWITH_OPENEXR=1" ]
            ++ stdenv.lib.optionals (stdenv.system == "x86_64-linux")
                  [ "-DCMAKE_CXX_FLAGS=-fPIC" "-DCMAKE_C_FLAGS=-fPIC" ];

  meta = with stdenv.lib; {
    description = "Novel computer vision C++ library with customizable algorithms and data structures";
    homepage = http://hci.iwr.uni-heidelberg.de/vigra;
    license = licenses.mit;
    maintainers = [ maintainers.viric ];
    platforms = platforms.linux;
  };
}

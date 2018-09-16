{ stdenv, fetchurl, boost, cmake, fftw, fftwSinglePrec, hdf5, ilmbase
, libjpeg, libpng, libtiff, openexr, python2Packages }:

let
  inherit (python2Packages) python numpy;
  # Might want to use `python2.withPackages(ps: [ps.numpy]);` here...
in stdenv.mkDerivation rec {
  name = "vigra-${version}";
  version = "1.11.1";

  src = fetchurl {
    url = "https://github.com/ukoethe/vigra/archive/Version-${stdenv.lib.replaceChars ["."] ["-"] version}.tar.gz";
    sha256 = "03i5wfscv83jb8vnwwhfmm8yfiniwkvk13myzhr1kbwbs9884wdj";
  };

  NIX_CFLAGS_COMPILE = "-I${ilmbase.dev}/include/OpenEXR";

  buildInputs = [ boost cmake fftw fftwSinglePrec hdf5 ilmbase libjpeg libpng
                  libtiff numpy openexr python ];

  preConfigure = "cmakeFlags+=\" -DVIGRANUMPY_INSTALL_DIR=$out/lib/${python.libPrefix}/site-packages\"";

  cmakeFlags = [ "-DWITH_OPENEXR=1" ]
            ++ stdenv.lib.optionals (stdenv.hostPlatform.system == "x86_64-linux")
                  [ "-DCMAKE_CXX_FLAGS=-fPIC" "-DCMAKE_C_FLAGS=-fPIC" ];

  enableParallelBuilding = true;

  # fails with "./test_watersheds3d: error while loading shared libraries: libvigraimpex.so.11: cannot open shared object file: No such file or directory"
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Novel computer vision C++ library with customizable algorithms and data structures";
    homepage = https://hci.iwr.uni-heidelberg.de/vigra;
    license = licenses.mit;
    maintainers = [ maintainers.viric ];
    platforms = platforms.linux;
  };
}

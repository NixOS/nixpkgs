{ stdenv, fetchurl, boost, cmake, fftw, fftwSinglePrec, hdf5, ilmbase
, libjpeg, libpng, libtiff, openexr, python2Packages }:

let
  inherit (python2Packages) python numpy;
  # Might want to use `python2.withPackages(ps: [ps.numpy]);` here...
in stdenv.mkDerivation rec {
  pname = "vigra";
  version = "1.11.1";

  src = fetchurl {
    url = "https://github.com/ukoethe/vigra/archive/Version-${stdenv.lib.replaceChars ["."] ["-"] version}.tar.gz";
    sha256 = "03i5wfscv83jb8vnwwhfmm8yfiniwkvk13myzhr1kbwbs9884wdj";
  };

  NIX_CFLAGS_COMPILE = "-I${ilmbase.dev}/include/OpenEXR";

  # Fixes compilation with clang (on darwin) see https://github.com/ukoethe/vigra/issues/414
  patches =
    let clangPatch = fetchurl { url = "https://github.com/ukoethe/vigra/commit/81958d302494e137f98a8b1d7869841532f90388.patch";
                                sha256 = "1i1w6smijgb5z8bg9jaq84ccy00k2sxm87s37lgjpyix901gjlgi"; };
    in [ clangPatch ];

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
    platforms = platforms.unix;
  };
}

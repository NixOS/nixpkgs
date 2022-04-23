{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, fetchpatch
, boost
, cmake
, fftw
, fftwSinglePrec
, hdf5
, ilmbase
, libjpeg
, libpng
, libtiff
, openexr
, python3
}:

let
  python = python3.withPackages (py: with py; [ numpy ]);
in
stdenv.mkDerivation rec {
  pname = "vigra";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "ukoethe";
    repo = "vigra";
    rev = "Version-${lib.replaceChars ["."] ["-"] version}";
    sha256 = "sha256-tD6tdoT4mWBtzkn4Xv3nNIkBQmeqNqzI1AVxUbP76Mk=";
  };

  NIX_CFLAGS_COMPILE = "-I${ilmbase.dev}/include/OpenEXR";


  patches = [
    # Fixes compilation with clang (on darwin) see https://github.com/ukoethe/vigra/issues/414
    (fetchpatch {
      name = "clangPatch";
      url = "https://github.com/ukoethe/vigra/commit/81958d302494e137f98a8b1d7869841532f90388.patch";
      hash = "sha256-UtV7cO5lMU1W7viMdcgMocHt7UWobqtA4+ivHztm8bs=";
    })
    #Fixes error: C++17 does not allow dynamic exception specifications
    (fetchpatch {
      name = "dynamicException";
      url = "https://github.com/ukoethe/vigra/commit/dc730be49fc8def4304a651fa525e43b7754955e.patch";
      hash = "sha256-2MFzqQCrdxWiINs4UzwSIVbfcmChawaBOJebtAW8MRA=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost
    fftw
    fftwSinglePrec
    hdf5
    ilmbase
    libjpeg
    libpng
    libtiff
    openexr
    python
  ];

  preConfigure = "cmakeFlags+=\" -DVIGRANUMPY_INSTALL_DIR=$out/lib/${python.libPrefix}/site-packages\"";

  cmakeFlags = [ "-DWITH_OPENEXR=1" ]
    ++ lib.optionals (stdenv.hostPlatform.system == "x86_64-linux")
    [ "-DCMAKE_CXX_FLAGS=-fPIC" "-DCMAKE_C_FLAGS=-fPIC" ];

  # fails with "./test_watersheds3d: error while loading shared libraries: libvigraimpex.so.11: cannot open shared object file: No such file or directory"
  doCheck = false;

  meta = with lib; {
    description = "Novel computer vision C++ library with customizable algorithms and data structures";
    homepage = "https://hci.iwr.uni-heidelberg.de/vigra";
    license = licenses.mit;
    maintainers = [ maintainers.viric ];
    platforms = platforms.unix;
  };
}

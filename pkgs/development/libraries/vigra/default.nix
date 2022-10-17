{ lib
, stdenv
, fetchFromGitHub
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
  version = "unstable-2022-01-11";

  src = fetchFromGitHub {
    owner = "ukoethe";
    repo = "vigra";
    rev = "093d57d15c8c237adf1704d96daa6393158ce299";
    sha256 = "sha256-pFANoT00Wkh1/Dyd2x75IVTfyaoVA7S86tafUSr29Og=";
  };

  NIX_CFLAGS_COMPILE = "-I${ilmbase.dev}/include/OpenEXR";

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

  meta = with lib; {
    description = "Novel computer vision C++ library with customizable algorithms and data structures";
    homepage = "https://hci.iwr.uni-heidelberg.de/vigra";
    license = licenses.mit;
    maintainers = [ maintainers.viric ];
    platforms = platforms.unix;
  };
}

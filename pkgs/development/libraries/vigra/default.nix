{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, boost
, cmake
, fftw
, fftwSinglePrec
, hdf5
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

  patches = [
    # Support OpenEXR 3.x
    # https://github.com/ukoethe/vigra/issues/496
    (fetchurl {
      url = "https://src.fedoraproject.org/rpms/vigra/raw/25fc581843ceffa0a7240cc5fed79f4af3fc94aa/f/vigra-openexr3.patch";
      hash = "sha256-L6S7nEgR6duqIgg816+EAp6jKbzxiF/lGOThWJb/4Vw=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost
    fftw
    fftwSinglePrec
    hdf5
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

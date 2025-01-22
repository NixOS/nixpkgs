{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cmake,
  fftw,
  fftwSinglePrec,
  hdf5,
  libjpeg,
  libpng,
  libtiff,
  openexr,
  python3,
}:

let
  python = python3.withPackages (py: with py; [ numpy ]);
in
stdenv.mkDerivation rec {
  pname = "vigra";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "ukoethe";
    repo = "vigra";
    tag = "Version-${lib.replaceStrings [ "." ] [ "-" ] version}";
    hash = "sha256-ZmHj1BSyoMBCuxI5hrRiBEb5pDUsGzis+T5FSX27UN8=";
  };

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

  cmakeFlags =
    [
      "-DWITH_OPENEXR=1"
      "-DVIGRANUMPY_INSTALL_DIR=${placeholder "out"}/${python.sitePackages}"
    ]
    ++ lib.optionals (stdenv.hostPlatform.system == "x86_64-linux") [
      "-DCMAKE_CXX_FLAGS=-fPIC"
      "-DCMAKE_C_FLAGS=-fPIC"
    ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Novel computer vision C++ library with customizable algorithms and data structures";
    mainProgram = "vigra-config";
    homepage = "https://hci.iwr.uni-heidelberg.de/vigra";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}

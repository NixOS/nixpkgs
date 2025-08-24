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
stdenv.mkDerivation (finalAttrs: {
  pname = "vigra";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "ukoethe";
    repo = "vigra";
    tag = "Version-${lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version}";
    hash = "sha256-ZmHj1BSyoMBCuxI5hrRiBEb5pDUsGzis+T5FSX27UN8=";
  };

  patches = [
    # Patches to fix compiling on LLVM 19 from https://github.com/ukoethe/vigra/pull/592
    ./fix-llvm-19-1.patch
    ./fix-llvm-19-2.patch
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

  postPatch = ''
    chmod +x config/run_test.sh.in
    patchShebangs --build config/run_test.sh.in
  '';

  cmakeFlags = [
    "-DWITH_OPENEXR=1"
    "-DVIGRANUMPY_INSTALL_DIR=${placeholder "out"}/${python.sitePackages}"
  ]
  ++ lib.optionals (stdenv.hostPlatform.system == "x86_64-linux") [
    "-DCMAKE_CXX_FLAGS=-fPIC"
    "-DCMAKE_C_FLAGS=-fPIC"
  ];

  enableParallelBuilding = true;

  passthru = {
    tests = {
      check = finalAttrs.finalPackage.overrideAttrs (previousAttrs: {
        doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
      });
    };
  };

  meta = with lib; {
    description = "Novel computer vision C++ library with customizable algorithms and data structures";
    mainProgram = "vigra-config";
    homepage = "https://hci.iwr.uni-heidelberg.de/vigra";
    license = licenses.mit;
    maintainers = with maintainers; [ ShamrockLee ];
    platforms = platforms.unix;
  };
})

{ fetchurl
, stdenv
, lib
, gfortran
, perl
, llvmPackages
, precision ? "double"
, enableMpi ? false
, mpi
, withDoc ? stdenv.cc.isGNU
, testers
}:

assert lib.elem precision [ "single" "double" "long-double" "quad-precision" ];

stdenv.mkDerivation (finalAttrs: {
  pname = "fftw-${precision}";
  version = "3.3.10";

  src = fetchurl {
    urls = [
      "https://fftw.org/fftw-${finalAttrs.version}.tar.gz"
      "ftp://ftp.fftw.org/pub/fftw/fftw-${finalAttrs.version}.tar.gz"
    ];
    sha256 = "sha256-VskyVJhSzdz6/as4ILAgDHdCZ1vpIXnlnmIVs0DiZGc=";
  };

  outputs = [ "out" "dev" "man" ]
    ++ lib.optional withDoc "info"; # it's dev-doc only
  outputBin = "dev"; # fftw-wisdom

  cmakeFlags = []
    ++ stdenv.lib.optional (!enableSharedLibs) "-DBUILD_SHARED_LIBS=ON"
    ++ stdenv.lib.optional (!doCheck) "-DBUILD_TESTS=OFF";
#    ++ stdenv.lib.optional (!doCheck) "-DBUILD_TESTING=OFF";
    ++ stdenv.lib.optional (!doCheck) "-DENABLE_THREADS=ON";
    ++ stdenv.lib.optional (!doCheck) "-DENABLE_FLOAT=OFF";
    ++ stdenv.lib.optional (!doCheck) "-DENABLE_LONG_DOUBLE=ON"
    ++ stdenv.lib.optional (!doCheck) "-DENABLE_QUAD_PRECISION=OFF"

#    ++ stdenv.lib.optional enableCfp "-DBUILD_CFP=ON"
#    ++ stdenv.lib.optional enableZforp "-DBUILD_ZFORP=ON"
#    ++ stdenv.lib.optional enableZFPy "-DBUILD_ZFPY=ON"
#    ++ stdenv.lib.optional (!enableUtilities) "-DBUILD_UTILITIES=OFF" # Default on
#    ++ stdenv.lib.optional enableExamples "-DBUILD_EXAMPLES=ON"
#    ++ stdenv.lib.optional (!enableTestingSmall) "-DBUILD_TESTING_SMALL=OFF" # Default on
#    ++ stdenv.lib.optional enableTestingLarge "-DBUILD_TESTING_LARGE=ON"

  nativeBuildInputs = [ cmake gfortran ];
    ++ stdenv.lib.optional;

  buildInputs = lib.optionals stdenv.cc.isClang [
    # TODO: This may mismatch the LLVM version sin the stdenv, see #79818.
    llvmPackages.openmp
  ] ++ lib.optional enableMpi mpi;

  configureFlags = [
    "--enable-shared"
    "--enable-threads"
    "--enable-openmp"
  ]

  ++ lib.optional (precision != "double") "--enable-${precision}"
  # https://www.fftw.org/fftw3_doc/SIMD-alignment-and-fftw_005fmalloc.html
  # FFTW will try to detect at runtime whether the CPU supports these extensions
  ++ lib.optional (stdenv.isx86_64 && (precision == "single" || precision == "double"))
    "--enable-sse2 --enable-avx --enable-avx2 --enable-avx512 --enable-avx128-fma"
  ++ lib.optional enableMpi "--enable-mpi"
  # doc generation causes Fortran wrapper generation which hard-codes gcc
  ++ lib.optional (!withDoc) "--disable-doc";

  # fftw builds with -mtune=native by default
  postPatch = ''
    substituteInPlace configure --replace "-mtune=native" "-mtune=generic"
  '';

  enableParallelBuilding = true;

  nativeCheckInputs = [ perl ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "Fastest Fourier Transform in the West library";
    homepage = "http://www.fftw.org/";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    pkgConfigModules = [
      {
        "single" = "fftw3f";
        "double" = "fftw3";
        "long-double" = "fftw3l";
        "quad-precision" = "fftw3q";
      }.${precision}
    ];
    platforms = platforms.unix;
  };
})

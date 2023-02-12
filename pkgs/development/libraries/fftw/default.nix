{ fetchurl
, stdenv
, lib
, gfortran
, perl
, llvmPackages
, precision ? "double"
, enableAvx ? stdenv.hostPlatform.avxSupport
, enableAvx2 ? stdenv.hostPlatform.avx2Support
, enableAvx512 ? stdenv.hostPlatform.avx512Support
, enableFma ? stdenv.hostPlatform.fmaSupport
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

  nativeBuildInputs = [ gfortran ];

  buildInputs = lib.optionals stdenv.cc.isClang [
    # TODO: This may mismatch the LLVM version sin the stdenv, see #79818.
    llvmPackages.openmp
  ] ++ lib.optional enableMpi mpi;

  configureFlags =
    [ "--enable-shared"
      "--enable-threads"
    ]
    ++ lib.optional (precision != "double") "--enable-${precision}"
    # all x86_64 have sse2
    # however, not all float sizes fit
    ++ lib.optional (stdenv.isx86_64 && (precision == "single" || precision == "double") )  "--enable-sse2"
    ++ lib.optional enableAvx "--enable-avx"
    ++ lib.optional enableAvx2 "--enable-avx2"
    ++ lib.optional enableAvx512 "--enable-avx512"
    ++ lib.optional enableFma "--enable-fma"
    ++ [ "--enable-openmp" ]
    ++ lib.optional enableMpi "--enable-mpi"
    # doc generation causes Fortran wrapper generation which hard-codes gcc
    ++ lib.optional (!withDoc) "--disable-doc";

  enableParallelBuilding = true;

  nativeCheckInputs = [ perl ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "Fastest Fourier Transform in the West library";
    homepage = "http://www.fftw.org/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.spwhitt ];
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

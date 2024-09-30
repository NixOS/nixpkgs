{ fetchurl
, fetchpatch
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

  patches = [
    (fetchpatch {
      name = "remove_missing_FFTW3LibraryDepends.patch";
      url = "https://github.com/FFTW/fftw3/pull/338/commits/f69fef7aa546d4477a2a3fd7f13fa8b2f6c54af7.patch";
      hash = "sha256-lzX9kAHDMY4A3Td8necXwYLcN6j8Wcegi3A7OIECKeU=";
    })
  ];

  outputs = [ "out" "dev" "man" ]
    ++ lib.optional withDoc "info"; # it's dev-doc only
  outputBin = "dev"; # fftw-wisdom

  nativeBuildInputs = [ gfortran ];

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
  ++ lib.optional (stdenv.hostPlatform.isx86_64 && (precision == "single" || precision == "double"))
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
    homepage = "https://www.fftw.org/";
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

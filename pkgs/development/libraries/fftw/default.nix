{ fetchurl
, stdenv
, lib
, cmake
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
, enableFortran ? stdenv.cc.isGNU # generate Fortran wrapper with hardcoded gcc
}:

with lib;

assert elem precision [ "single" "double" "long-double" "quad-precision" ];

stdenv.mkDerivation rec {
  pname = "fftw-${precision}";
  version = "3.3.10";

  src = fetchurl {
    urls = [
      "https://fftw.org/fftw-${version}.tar.gz"
      "ftp://ftp.fftw.org/pub/fftw/fftw-${version}.tar.gz"
    ];
    sha256 = "sha256-VskyVJhSzdz6/as4ILAgDHdCZ1vpIXnlnmIVs0DiZGc=";
  };

  # fix package version in cmake files
  # https://github.com/FFTW/fftw3/issues/130#issuecomment-1409884653
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "set (FFTW_VERSION 3.3.9)" "set (FFTW_VERSION 3.3.10)"
  '';

  outputs = [ "out" "dev" ];
  #outputBin = "dev"; # fftw-wisdom # not in cmake

  nativeBuildInputs = [
    gfortran
    cmake
  ];

  buildInputs = optionals stdenv.cc.isClang [
    # TODO: This may mismatch the LLVM version sin the stdenv, see #79818.
    llvmPackages.openmp
  ] ++ optional enableMpi mpi;

  cmakeFlags =
    let
      # all x86_64 have sse2
      # however, not all float sizes fit
      enableSse2 = (stdenv.isx86_64 && (precision == "single" || precision == "double"));
      enableSse = enableSse2;
    in
    [
      "-DBUILD_SHARED_LIBS=ON"
      #"-DBUILD_TESTS=ON" # default ON
      "-DENABLE_OPENMP=ON" # Use OpenMP for multithreading
      "-DENABLE_THREADS=ON" # Use pthread for multithreading
    ]
    # default precision is double
    ++ optional (precision == "single") "-DENABLE_FLOAT=ON"
    ++ optional (precision == "long-double") "-DENABLE_LONG_DOUBLE=ON"
    ++ optional (precision == "quad-precision") "-DENABLE_QUAD_PRECISION=ON"
    ++ optional enableSse "-DENABLE_SSE=ON"
    ++ optional enableSse2 "-DENABLE_SSE2=ON"
    ++ optional enableAvx "-DENABLE_AVX=ON"
    ++ optional enableAvx2 "-DENABLE_AVX2=ON"
    #++ optional enableAvx512 "-DENABLE_AVX512=ON" # missing in cmake
    #++ optional enableFma "-DENABLE_FMA=ON" # missing in cmake
    #++ optional enableMpi "-DENABLE_MPI=ON" # missing in cmake
    ++ optional (!enableFortran) "-DDISABLE_FORTRAN=ON"
  ;

  enableParallelBuilding = true;

  nativeCheckInputs = [ perl ];

  meta = with lib; {
    description = "Fastest Fourier Transform in the West library";
    homepage = "http://www.fftw.org/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.spwhitt ];
    platforms = platforms.unix;
  };
}

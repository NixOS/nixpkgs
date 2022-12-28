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

  outputs = [ "out" "dev" "man" ]
    ++ optional withDoc "info"; # it's dev-doc only
  outputBin = "dev"; # fftw-wisdom

  nativeBuildInputs = [ gfortran ];

  buildInputs = optionals stdenv.cc.isClang [
    # TODO: This may mismatch the LLVM version sin the stdenv, see #79818.
    llvmPackages.openmp
  ] ++ optional enableMpi mpi;

  configureFlags =
    [ "--enable-shared"
      "--enable-threads"
    ]
    ++ optional (precision != "double") "--enable-${precision}"
    # all x86_64 have sse2
    # however, not all float sizes fit
    ++ optional (stdenv.isx86_64 && (precision == "single" || precision == "double") )  "--enable-sse2"
    ++ optional enableAvx "--enable-avx"
    ++ optional enableAvx2 "--enable-avx2"
    ++ optional enableAvx512 "--enable-avx512"
    ++ optional enableFma "--enable-fma"
    ++ [ "--enable-openmp" ]
    ++ optional enableMpi "--enable-mpi"
    # doc generation causes Fortran wrapper generation which hard-codes gcc
    ++ optional (!withDoc) "--disable-doc";

  enableParallelBuilding = true;

  checkInputs = [ perl ];

  meta = with lib; {
    description = "Fastest Fourier Transform in the West library";
    homepage = "http://www.fftw.org/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.spwhitt ];
    platforms = platforms.unix;
  };
}

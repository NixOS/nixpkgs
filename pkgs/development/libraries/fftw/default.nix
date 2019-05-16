{ fetchurl, stdenv, lib, precision ? "double", perl }:

with lib;

assert elem precision [ "single" "double" "long-double" "quad-precision" ];

let
  version = "3.3.8";
  withDoc = stdenv.cc.isGNU;
in

stdenv.mkDerivation rec {
  name = "fftw-${precision}-${version}";

  src = fetchurl {
    urls = [
      "http://fftw.org/fftw-${version}.tar.gz"
      "ftp://ftp.fftw.org/pub/fftw/fftw-${version}.tar.gz"
    ];
    sha256 = "00z3k8fq561wq2khssqg0kallk0504dzlx989x3vvicjdqpjc4v1";
  };

  outputs = [ "out" "dev" "man" ]
    ++ optional withDoc "info"; # it's dev-doc only
  outputBin = "dev"; # fftw-wisdom

  configureFlags =
    [ "--enable-shared" "--disable-static"
      "--enable-threads"
    ]
    ++ optional (precision != "double") "--enable-${precision}"
    # all x86_64 have sse2
    # however, not all float sizes fit
    ++ optional (stdenv.isx86_64 && (precision == "single" || precision == "double") )  "--enable-sse2"
    ++ optional (stdenv.cc.isGNU && !stdenv.hostPlatform.isMusl) "--enable-openmp"
    # doc generation causes Fortran wrapper generation which hard-codes gcc
    ++ optional (!withDoc) "--disable-doc";

  enableParallelBuilding = true;

  checkInputs = [ perl ];

  meta = with stdenv.lib; {
    description = "Fastest Fourier Transform in the West library";
    homepage = http://www.fftw.org/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.spwhitt ];
    platforms = platforms.unix;
  };
}

{ fetchurl, stdenv, lib, precision ? "double" }:

with lib;

assert elem precision [ "single" "double" "long-double" "quad-precision" ];

let version = "3.3.4"; in

stdenv.mkDerivation rec {
  name = "fftw-${precision}-${version}";

  src = fetchurl {
    url = "ftp://ftp.fftw.org/pub/fftw/fftw-${version}.tar.gz";
    sha256 = "10h9mzjxnwlsjziah4lri85scc05rlajz39nqf3mbh4vja8dw34g";
  };

  configureFlags =
    [ "--enable-shared" "--disable-static"
      "--enable-threads"
    ]
    ++ optional (precision != "double") "--enable-${precision}"
    # all x86_64 have sse2
    ++ optional stdenv.isx86_64 "--enable-sse2"
    ++ optional stdenv.cc.isGNU "--enable-openmp";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Fastest Fourier Transform in the West library";
    homepage = http://www.fftw.org/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.spwhitt ];
    platforms = platforms.unix;
  };
}

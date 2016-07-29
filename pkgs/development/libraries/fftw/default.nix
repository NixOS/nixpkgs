{ fetchurl, stdenv, lib, precision ? "double" }:

with lib;

assert elem precision [ "single" "double" "long-double" "quad-precision" ];

let version = "3.3.5-rc1"; in

stdenv.mkDerivation rec {
  name = "fftw-${precision}-${version}";

  src = fetchurl {
    url = "ftp://ftp.fftw.org/pub/fftw/fftw-${version}.tar.gz";
    sha256 = "086z9xq5jy58w5lqygq4rpragcy2r0dz3lzci3mh0vghs9c6zgk6";
  };

  outputs = [ "dev" "out" "doc" ]; # it's dev-doc only
  outputBin = "dev"; # fftw-wisdom

  configureFlags =
    [ "--enable-shared" "--disable-static"
      "--enable-threads"
    ]
    ++ optional (precision != "double") "--enable-${precision}"
    # all x86_64 have sse2
    # however, not all float sizes fit
    ++ optional (stdenv.isx86_64 && (precision == "single" || precision == "double") )  "--enable-sse2"
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

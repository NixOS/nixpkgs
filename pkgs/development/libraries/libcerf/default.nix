{ stdenv, lib, fetchurl, cmake, perl, gnuplot }:

stdenv.mkDerivation rec {
  pname = "libcerf";
  version = "2.4";

  src = fetchurl {
    url = "https://jugit.fz-juelich.de/mlz/libcerf/-/archive/v${version}/libcerf-v${version}.tar.gz";
    sha256 = "sha256-CAswrlZMPavjuJJkUira9WR+x1QCFXK+5UkpaXsnbNw=";
  };

  nativeBuildInputs = [ cmake perl ];

  passthru.tests = {
    inherit gnuplot;
  };

  meta = with lib; {
    description = "Complex error (erf), Dawson, Faddeeva, and Voigt function library";
    homepage = "https://jugit.fz-juelich.de/mlz/libcerf";
    license = licenses.mit;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.all;
  };
}

{ stdenv, lib, fetchurl, cmake, perl }:

stdenv.mkDerivation rec {
  pname = "libcerf";
  version = "1.13";

  src = fetchurl {
    url = "https://jugit.fz-juelich.de/mlz/libcerf/-/archive/v${version}/libcerf-v${version}.tar.gz";
    sha256 = "01d3fr4qa0080xdgp66mjbsa884qivn9y83p7rdyz2l3my0rysg4";
  };

  nativeBuildInputs = [ cmake perl ];

  meta = with lib; {
    description = "Complex error (erf), Dawson, Faddeeva, and Voigt function library";
    homepage = https://jugit.fz-juelich.de/mlz/libcerf;
    license = licenses.mit;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.all;
  };
}

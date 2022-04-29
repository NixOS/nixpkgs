{ stdenv, lib, fetchurl, cmake, perl }:

stdenv.mkDerivation rec {
  pname = "libcerf";
  version = "2.0";

  src = fetchurl {
    url = "https://jugit.fz-juelich.de/mlz/libcerf/-/archive/v${version}/libcerf-v${version}.tar.gz";
    sha256 = "05lpaxmy6275nbzvf1ahxcfymyph89pvlgg8h9sp9iwal4g8nvn8";
  };

  nativeBuildInputs = [ cmake perl ];

  meta = with lib; {
    description = "Complex error (erf), Dawson, Faddeeva, and Voigt function library";
    homepage = "https://jugit.fz-juelich.de/mlz/libcerf";
    license = licenses.mit;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.all;
  };
}

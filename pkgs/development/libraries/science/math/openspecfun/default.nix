{ lib, stdenv, fetchurl, gfortran }:

stdenv.mkDerivation {
  name = "openspecfun-0.5.3";
  src = fetchurl {
    url = "https://github.com/JuliaLang/openspecfun/archive/v0.5.3.tar.gz";
    sha256 = "1rs1bv8jq751fv9vq79890wqf9xlbjc7lvz3ighzyfczbyjcf18m";
  };

  makeFlags = [ "prefix=$(out)" ];

  nativeBuildInputs = [ gfortran ];

  meta = {
    description = "A collection of special mathematical functions";
    homepage = "https://github.com/JuliaLang/openspecfun";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ttuegel ];
    platforms = lib.platforms.all;
  };
}

{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "utf8proc-${version}";
  version = "2.3.0";

  src = fetchurl {
    url = "https://github.com/JuliaLang/utf8proc/archive/v${version}.tar.gz";
    sha256 = "03lk8y9zmqax3yk7d1nmgb2fsk83p9cfj6mb3i49bawvnm4ml9n0";
  };

  makeFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    description = "A clean C library for processing UTF-8 Unicode data";
    homepage = https://julialang.org/utf8proc;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.ftrvxmtrx ];
  };
}

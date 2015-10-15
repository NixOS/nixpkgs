{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "utf8proc-${version}";
  version = "1.3";

  src = fetchurl {
    url = "https://github.com/JuliaLang/utf8proc/archive/v${version}.tar.gz";
    sha256 = "07r7djkmd399wl9cn0s2iqjhmm7l5iifp5h1yf2in9s366mlhkkg";
  };

  makeFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    description = "A clean C library for processing UTF-8 Unicode data";
    homepage = http://julialang.org/utf8proc;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.ftrvxmtrx ];
  };
}

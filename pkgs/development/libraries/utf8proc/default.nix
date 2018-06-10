{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "utf8proc-${version}";
  version = "2.1.1";

  src = fetchurl {
    url = "https://github.com/JuliaLang/utf8proc/archive/v${version}.tar.gz";
    sha256 = "1cnpigrazhslw65s4j1a56j7p6d7d61wsxxjf1218i9mkwv2yw17";
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

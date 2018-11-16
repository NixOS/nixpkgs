{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "utf8proc-${version}";
  version = "2.2.0";

  src = fetchurl {
    url = "https://github.com/JuliaLang/utf8proc/archive/v${version}.tar.gz";
    sha256 = "1gsxxp7vk36z1g5mg19kq10j35dks5f9slsab2xfazh5vgdx33rz";
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

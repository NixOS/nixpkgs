{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "utf8proc-${version}";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "JuliaLang";
    repo = "utf8proc";
    rev = "v${version}";
    sha256 = "0z24pfdym2m0f92qyf2wc8rai91q5bv021jxhxankdhb3f8hmqf9";
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

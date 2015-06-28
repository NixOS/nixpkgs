{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "utf8proc-${version}";
  version = "v1.2";

  src = fetchFromGitHub {
    owner = "JuliaLang";
    repo = "utf8proc";
    rev = "${version}";
    sha256 = "1ryjlcnpfm7fpkq6444ybi576hbnh2l0w7kjhbqady5lxwjyg3pf";
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

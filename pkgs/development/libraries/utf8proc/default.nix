{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "utf8proc";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "JuliaStrings";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xlkazhdnja4lksn5c9nf4bln5gjqa35a8gwlam5r0728w0h83qq";
  };

  makeFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    description = "A clean C library for processing UTF-8 Unicode data";
    homepage = "https://juliastrings.github.io/utf8proc/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.ftrvxmtrx ];
  };
}

{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "utf8proc";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "JuliaStrings";
    repo = pname;
    rev = "v${version}";
    sha256 = "1jhjl7nw6262ks5zrk447qmh6z2r5rrnnrm742dk33d7031g3s55";
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

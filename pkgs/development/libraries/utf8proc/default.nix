{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "utf8proc";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "JuliaStrings";
    repo = pname;
    rev = "v${version}";
    sha256 = "1i42hqwc8znqii9brangwkxk5cyc2lk95ip405fg88zr7z2ncr34";
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

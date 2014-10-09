{ stdenv, fetchurl, m4 }:

stdenv.mkDerivation rec {
  name = "gforth-0.7.3";
  src = fetchurl {
    url = "http://ftp.gnu.org/gnu/gforth/gforth-0.7.3.tar.gz";
    sha256 = "1c1bahc9ypmca8rv2dijiqbangm1d9av286904yw48ph7ciz4qig";
  };
  buildInputs = [ m4 ];
}
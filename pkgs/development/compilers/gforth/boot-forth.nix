{ lib, stdenv, fetchurl, m4 }:

let
  version = "0.7.3";
in
stdenv.mkDerivation {
  pname = "gforth-boot";
  inherit version;
  src = fetchurl {
    url = "https://ftp.gnu.org/gnu/gforth/gforth-${version}.tar.gz";
    sha256 = "1c1bahc9ypmca8rv2dijiqbangm1d9av286904yw48ph7ciz4qig";
  };

  buildInputs = [ m4 ];

  configureFlags = lib.optionals stdenv.isDarwin [ "--build=x86_64-apple-darwin" ];

  meta = {
    description = "Forth implementation of the GNU project (outdated version used to bootstrap)";
    homepage = "https://www.gnu.org/software/gforth/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
  };
}

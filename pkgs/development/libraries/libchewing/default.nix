{ stdenv, fetchurl }:

let
  pkgname = "libchewing";
  version = "0.3.5";

in stdenv.mkDerivation {
  name = "${pkgname}-${version}";

  src = fetchurl {
    url = "https://chewing.googlecode.com/files/${pkgname}-${version}.tar.bz2";
    sha1 = "5ee3941f0f62fa14fbda53e1032970b04a7a88b7";
  };
}

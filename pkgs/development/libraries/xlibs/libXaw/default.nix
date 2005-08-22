{stdenv, fetchurl, pkgconfig, xproto, libX11, libXt, libXmu, libXpm}:

stdenv.mkDerivation {
  name = "libXaw-7.0.2";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/libXaw-7.0.2.tar.bz2;
    md5 = "30d569f9560c1daac184d5be8085ce37";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [xproto libX11 libXt libXmu libXpm];
}

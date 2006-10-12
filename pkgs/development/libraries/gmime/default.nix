{stdenv, fetchurl, pkgconfig, glib, zlib}:

stdenv.mkDerivation {
  name = "gmime-2.2.1";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/gmime-2.2.1.tar.gz;
    md5 = "b05e4d6344c8465fb74386e5f1fed45c";
  };
  buildInputs = [pkgconfig glib zlib];
}

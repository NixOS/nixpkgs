{stdenv, fetchurl, static ? false}:

stdenv.mkDerivation {
  name = "zlib-1.2.3";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/zlib-1.2.3.tar.gz;
    md5 = "debc62758716a169df9f62e6ab2bc634";
  };
  configureFlags = if static then "" else "--shared";
}

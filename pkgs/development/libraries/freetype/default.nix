{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "freetype-2.1.10";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/freetype-2.1.10.tar.bz2;
    md5 = "a4012e7d1f6400df44a16743b11b8423";
  };
}

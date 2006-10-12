{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "freetype-2.2.1";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/freetype-2.2.1.tar.bz2;
    md5 = "5b2f827082c544392a7701f7423f0781";
  };
}

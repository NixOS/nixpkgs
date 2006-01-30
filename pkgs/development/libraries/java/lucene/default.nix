{stdenv, fetchurl} :

stdenv.mkDerivation {
  name = "lucene-1.4.1";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/lucene-1.4.1.tar.gz;
    md5 = "656a6f40f5b8f7d2e19453436848bfe8";
  };
}
{stdenv, fetchurl} :

stdenv.mkDerivation {
  name = "jflex-1.4.1";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/jflex-1.4.1.tar.gz;
    md5 = "9e4be6e826e6b344e84c0434d6fd4b46";
  };
}

{stdenv, fetchurl, jdk} :

stdenv.mkDerivation {
  name = "java-cup-10k";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/java_cup_v10k.tar.gz;
    md5 = "8b11edfec13c590ea443d0f0ae0da479";
  };

  inherit jdk;
}

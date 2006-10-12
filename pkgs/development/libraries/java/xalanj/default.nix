{stdenv, fetchurl}:

/*
This is a binary package containing the jars... yuck!
*/
stdenv.mkDerivation {
  name = "xalanj-2.7.0";
  directory = "xalan-j_2_7_0";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/xalan-j_2_7_0-bin-2jars.tar.gz;
    md5 = "4d7b03dcaf2484b5f9685cc4309a9910";
  };
  builder = ./builder.sh;
}

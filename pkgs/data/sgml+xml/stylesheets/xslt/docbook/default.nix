{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "docbook-xsl-1.71.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/docbook-xsl-1.71.0.tar.bz2;
    md5 = "42397442255e3c903b16d896446c3ce1";
  };
}

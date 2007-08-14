{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "docbook5-xsl-1.73.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://kent.dl.sourceforge.net/sourceforge/docbook/docbook-xsl-ns-1.73.0.tar.bz2;
    sha256 = "1ldg8jqbwqy2il7ghvyv49nn45n9aj0l5w5l04sh305z6bww67nk";
  };
}

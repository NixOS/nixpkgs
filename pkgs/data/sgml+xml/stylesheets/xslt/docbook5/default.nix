{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "docbook5-xsl-1.72.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/docbook/docbook5-xsl-1.72.0.tar.bz2;
    sha256 = "0iy7axmk3nvaqgxg5lh7qx39ad9g3qrgwikrp5w4z7bwlrpijfpx";
  };
}

{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "docbook-xsl-1.68.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/docbook/docbook-xsl-1.68.1.tar.bz2;
    md5 = "f4985efbc0f3411af8106928f8752fc5";
  };
}

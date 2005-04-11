{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "docbook-xsl-1.68.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/docbook-xsl-1.68.1.tar.bz2;
    md5 = "f4985efbc0f3411af8106928f8752fc5";
  };
}

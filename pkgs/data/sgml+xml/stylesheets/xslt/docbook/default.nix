{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "docbook-xsl-1.65.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/docbook-xsl-1.65.1.tar.gz;
    md5 = "2f7d446de5523ec34a19ccbe8caf387f";
  };
}

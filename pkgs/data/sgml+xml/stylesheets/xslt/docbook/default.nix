{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "docbook-xsl-1.65.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/docbook/docbook-xsl-1.65.1.tar.gz;
    md5 = "2f7d446de5523ec34a19ccbe8caf387f";
  };
}

{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "docbook-xsl-1.70.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/docbook/docbook-xsl-1.70.1.tar.gz;
    md5 = "3ac0ab99bfbfc9c631baa03eef0f719c";
  };
}

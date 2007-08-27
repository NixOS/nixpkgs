{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "docbook5-xsl-1.73.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/docbook/docbook-xsl-ns-1.73.1.tar.bz2;
    sha256 = "105irc94p04j0fj5vf5fschyxv9azkh2bsa69a796jax5ngpbahn";
  };
}

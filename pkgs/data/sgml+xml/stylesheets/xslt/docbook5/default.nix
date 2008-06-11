{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "docbook5-xsl-1.74.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/docbook/docbook-xsl-ns-1.74.0.tar.bz2;
    sha256 = "0253ymp0k9wb3zsxazz8p9q9fy83rkmp8c67vlk84x7f2i7vf3x9";
  };
}

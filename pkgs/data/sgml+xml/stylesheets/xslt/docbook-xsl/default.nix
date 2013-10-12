{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "docbook-xsl-1.78.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/docbook/docbook-xsl-1.78.1.tar.bz2;
    sha256 = "0rxl013ncmz1n6ymk2idvx3hix9pdabk8xn01cpcv32wmfb753y9";
  };
}

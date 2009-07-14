{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "docbook-xsl-1.72.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/docbook/docbook-xsl-1.72.0.tar.bz2;
    sha256 = "1cnrfgqz8pc9wnlgqjch2338ad7jki6d4h6b2fhaxn1a2201df5k";
  };
}

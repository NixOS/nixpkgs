{stdenv, fetchurl}:

derivation {
  name = "docbook-xsl-1.64.1";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://cesnet.dl.sourceforge.net/sourceforge/docbook/docbook-xsl-1.64.1.tar.gz;
    md5 = "ed766902e8381f6206d12f5c326fbd47";
  };
  stdenv = stdenv;
}

{stdenv, fetchurl}:

derivation {
  name = "docbook-xsl-1.62.4";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://belnet.dl.sourceforge.net/sourceforge/docbook/docbook-xsl-1.62.4.tar.gz;
    md5 = "4f33db39db7fa95b50143ad609d734a0";
  };
  stdenv = stdenv;
}

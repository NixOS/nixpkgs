{stdenv, fetchurl, libxml2}:

assert libxml2 != null;

derivation {
  name = "libxslt-1.1.0";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://xmlsoft.org/libxslt-1.1.0.tar.gz;
    md5 = "79a2c5307812e813e14f18b6fef9ca87";
  };
  stdenv = stdenv;
  libxml2 = libxml2;
}

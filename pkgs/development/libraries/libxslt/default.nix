{stdenv, fetchurl, libxml2}:

assert libxml2 != null;

stdenv.mkDerivation {
  name = "libxslt-1.1.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://xmlsoft.org/libxslt-1.1.0.tar.gz;
    md5 = "79a2c5307812e813e14f18b6fef9ca87";
  };
  libxml2 = libxml2;
}

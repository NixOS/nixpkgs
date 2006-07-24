{stdenv, fetchurl, libxml2}:

assert libxml2 != null;

stdenv.mkDerivation {
  name = "libxslt-1.1.15";
  src = fetchurl {
    url = ftp://xmlsoft.org/libxml2/libxslt-1.1.15.tar.gz;
    md5 = "238de9eda71b570ff7b78aaf65308fc6";
  };
  buildInputs = [libxml2];
}

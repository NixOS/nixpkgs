{stdenv, fetchurl, libxml2}:

assert libxml2 != null;

stdenv.mkDerivation {
  name = "libxslt-1.1.17";
  src = fetchurl {
    url = ftp://xmlsoft.org/libxslt/libxslt-1.1.17.tar.gz;
    md5 = "fde6a7a93c0eb14cba628692fa3a1000";
  };
  buildInputs = [libxml2];
}

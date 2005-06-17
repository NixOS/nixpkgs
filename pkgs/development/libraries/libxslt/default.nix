{stdenv, fetchurl, libxml2}:

assert libxml2 != null;

stdenv.mkDerivation {
  name = "libxslt-1.1.14";
  src = fetchurl {
    url = ftp://xmlsoft.org/libxslt-1.1.14.tar.gz;
    md5 = "db71660bb7d01ccd4e6be990af8d813b";
  };
  buildInputs = [libxml2];
}

{stdenv, fetchurl, libxml2}:

assert libxml2 != null;

stdenv.mkDerivation {
  name = "libxslt-1.1.10";
  src = fetchurl {
    url = ftp://xmlsoft.org/libxslt-1.1.10.tar.gz;
    md5 = "9839e6a309c7c97ffd260c8a2aa03cf5";
  };
  buildInputs = [libxml2];
}

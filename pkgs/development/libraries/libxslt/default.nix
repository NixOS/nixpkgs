{stdenv, fetchurl, libxml2}:

assert libxml2 != null;

stdenv.mkDerivation {
  name = "libxslt-1.1.12";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/libxslt-1.1.12.tar.gz;
    md5 = "cf82a767c016ff1668d1c295c47ae700";
  };
  buildInputs = [libxml2];
}

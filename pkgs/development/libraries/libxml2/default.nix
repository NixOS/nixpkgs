{stdenv, fetchurl, zlib}:

assert zlib != null;

stdenv.mkDerivation {
  name = "libxml2-2.6.8";
  src = fetchurl {
    url = ftp://ftp.gnome.org/pub/GNOME/sources/libxml2/2.6/libxml2-2.6.8.tar.bz2;
    md5 = "f8a0dc1983f67db388baa0f7c65d2b70";
  };
  propagatedBuildInputs = [zlib];
}

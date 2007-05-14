{stdenv, fetchurl, libxml2}:

assert libxml2 != null;

stdenv.mkDerivation {
  name = "libxslt-1.1.20";
  src = fetchurl {
    url = ftp://ftp.gnome.org/pub/GNOME/sources/libxslt/1.1/libxslt-1.1.20.tar.bz2;
    sha256 = "1gwc88dx7pb435qjr4gmf0klildrmp0hf56h2s3dm2578dwy1k21";
  };
  buildInputs = [libxml2];
}

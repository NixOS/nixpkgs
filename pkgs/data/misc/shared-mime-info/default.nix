{stdenv, fetchurl, pkgconfig, gettext, perl, perlXMLParser, intltool
, libxml2, glib}:

stdenv.mkDerivation rec {
  name = "shared-mime-info-1.1";

  src = fetchurl {
    url = "http://freedesktop.org/~hadess/${name}.tar.xz";
    sha256 = "0v70z5b6340jsjvdhf7brczpzq766wc1lsnjg9hc57ks2m5hjk8q";
  };

  buildInputs = [
    pkgconfig gettext intltool perl perlXMLParser libxml2 glib
  ];

  meta = {
    description = "A database of common MIME types";
    homepage = http://freedesktop.org/wiki/Software/shared-mime-info;
  };
}

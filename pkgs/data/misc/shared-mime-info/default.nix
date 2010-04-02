{stdenv, fetchurl, pkgconfig, gettext, perl, perlXMLParser, intltool
, libxml2, glib}:

stdenv.mkDerivation rec {
  name = "shared-mime-info-0.71";

  src = fetchurl {
    url = "http://freedesktop.org/~hadess/${name}.tar.bz2";
    sha256 = "1d8f97f17de77ae0d8a3a4ef357280ef444da87f4ce19170392712d0c2f6d04f";
  };

  buildInputs = [
    pkgconfig gettext intltool perl perlXMLParser libxml2 glib
  ];

  meta = {
    description = "A database of common MIME types";
    homepage = http://freedesktop.org/wiki/Software/shared-mime-info;
  };
}

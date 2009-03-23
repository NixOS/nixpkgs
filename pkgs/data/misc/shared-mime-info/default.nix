{stdenv, fetchurl, pkgconfig, gettext, perl, perlXMLParser, intltool
, libxml2, glib}:

stdenv.mkDerivation rec {
  name = "shared-mime-info-0.51";

  src = fetchurl {
    url = "http://freedesktop.org/~hadess/${name}.tar.bz2";
    sha256 = "1n7fn3vnqdq5c4xjyflwryxdb75cwsmw39hdpjy90swd841pw90w";
  };

  buildInputs = [
    pkgconfig gettext intltool perl perlXMLParser libxml2 glib
  ];

  meta = {
    description = "A database of common MIME types";
    homepage = http://freedesktop.org/wiki/Software/shared-mime-info;
  };
}

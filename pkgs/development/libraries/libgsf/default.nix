{stdenv, fetchurl, perl, perlXMLParser, pkgconfig, libxml2, glib, gettext}:

stdenv.mkDerivation {
  name = "libgsf-1.14.1";
  src = fetchurl {
    url = http://ftp.gnome.org/pub/gnome/sources/libgsf/1.14/libgsf-1.14.1.tar.bz2;
    md5 = "00de00b99382d0b7e034e0fffd8951d4";
  };
  buildInputs = [perl perlXMLParser pkgconfig libxml2 glib gettext];
}

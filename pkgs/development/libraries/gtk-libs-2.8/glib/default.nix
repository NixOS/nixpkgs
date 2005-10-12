{stdenv, fetchurl, pkgconfig, gettext, perl}:

assert pkgconfig != null && gettext != null && perl != null;

stdenv.mkDerivation {
  name = "glib-2.8.3";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.8/glib-2.8.3.tar.bz2;
    md5 = "58177fe64c189b86bac1625350512159";
  };
  buildInputs = [pkgconfig gettext perl];
}

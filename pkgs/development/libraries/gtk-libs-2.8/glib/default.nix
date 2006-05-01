{stdenv, fetchurl, pkgconfig, gettext, perl}:

assert pkgconfig != null && gettext != null && perl != null;

stdenv.mkDerivation {
  name = "glib-2.8.6";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.8/glib-2.8.6.tar.bz2;
    md5 = "fce6835fd8c99ab4c3e5213bc5bcd0ed";
  };
  buildInputs = [pkgconfig gettext perl];
}

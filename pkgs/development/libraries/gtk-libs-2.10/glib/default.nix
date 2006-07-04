{stdenv, fetchurl, pkgconfig, gettext, perl}:

assert pkgconfig != null && gettext != null && perl != null;

stdenv.mkDerivation {
  name = "glib-2.12.0";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.12/glib-2.12.0.tar.bz2;
    md5 = "ea8c7733ba443e3db04cf7a84060f408";
  };
  buildInputs = [pkgconfig gettext perl];
}

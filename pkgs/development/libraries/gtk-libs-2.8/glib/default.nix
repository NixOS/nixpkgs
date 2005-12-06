{stdenv, fetchurl, pkgconfig, gettext, perl}:

assert pkgconfig != null && gettext != null && perl != null;

stdenv.mkDerivation {
  name = "glib-2.8.4";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.8/glib-2.8.4.tar.bz2;
    md5 = "349a0f039f53584df11d2043d36c49b8";
  };
  buildInputs = [pkgconfig gettext perl];
}

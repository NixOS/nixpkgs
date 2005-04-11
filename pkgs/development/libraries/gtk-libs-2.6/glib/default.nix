{stdenv, fetchurl, pkgconfig, gettext, perl}:

assert pkgconfig != null && gettext != null && perl != null;

stdenv.mkDerivation {
  name = "glib-2.6.4";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.6/glib-2.6.4.tar.bz2;
    md5 = "af7eeb8aae764ff763418471ed6eb93d";
  };
  buildInputs = [pkgconfig gettext perl];
}

{stdenv, fetchurl, pkgconfig, gettext, perl}:

assert pkgconfig != null && gettext != null && perl != null;

stdenv.mkDerivation {
  name = "glib-2.4.2";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.4/glib-2.4.2.tar.bz2;
    md5 = "038b7cf535cbe016c6bb6033dbcf9acf";
  };
  buildInputs = [pkgconfig gettext perl];
}

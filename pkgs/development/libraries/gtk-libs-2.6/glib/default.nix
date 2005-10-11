{stdenv, fetchurl, pkgconfig, gettext, perl}:

assert pkgconfig != null && gettext != null && perl != null;

stdenv.mkDerivation {
  name = "glib-2.6.6";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.6/glib-2.6.6.tar.bz2;
    md5 = "dba15cceeaea39c5a61b6844d2b7b920";
  };
  buildInputs = [pkgconfig gettext perl];
}

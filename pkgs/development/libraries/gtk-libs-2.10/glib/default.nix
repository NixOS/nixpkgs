{stdenv, fetchurl, pkgconfig, gettext, perl}:

assert pkgconfig != null && gettext != null && perl != null;

stdenv.mkDerivation {
  name = "glib-2.12.1"; # <- sic! gtk 2.10 needs glib 2.12
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.12/glib-2.12.1.tar.bz2;
    md5 = "97786d2a03f0f190bd782749139dc10c";
  };
  buildInputs = [pkgconfig gettext perl];
}

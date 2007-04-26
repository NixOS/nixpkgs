{stdenv, fetchurl, pkgconfig, gettext, perl}:

assert pkgconfig != null && gettext != null && perl != null;

stdenv.mkDerivation {
  name = "glib-2.12.11"; # <- sic! gtk 2.10 needs glib 2.12
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/glib/2.12/glib-2.12.11.tar.bz2;
    md5 = "077a9917b673a9a0bc63f351786dde24";
  };
  buildInputs = [pkgconfig gettext perl];
}

{stdenv, fetchurl, pkgconfig, gettext, perl}:

assert pkgconfig != null && gettext != null && perl != null;

stdenv.mkDerivation {
  name = "glib-2.4.0";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.4/glib-2.4.0.tar.bz2;
    md5 = "0f5f4896782ec7ab6ea8c7c1d9958114";
  };
  buildInputs = [pkgconfig gettext perl];
}

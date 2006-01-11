{stdenv, fetchurl, pkgconfig, gettext, perl}:

assert pkgconfig != null && gettext != null && perl != null;

stdenv.mkDerivation {
  name = "glib-2.8.5";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.8/glib-2.8.5.tar.bz2;
    md5 = "334bb6892fb05aa34eae53707cc2726e";
  };
  buildInputs = [pkgconfig gettext perl];
}

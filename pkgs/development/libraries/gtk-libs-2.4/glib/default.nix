{stdenv, fetchurl, pkgconfig, gettext, perl}:

assert pkgconfig != null && gettext != null && perl != null;

stdenv.mkDerivation {
  name = "glib-2.4.6";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.4/glib-2.4.6.tar.bz2;
    md5 = "a45db7d82480da431f6cd00ea041a534";
  };
  buildInputs = [pkgconfig gettext perl];
}

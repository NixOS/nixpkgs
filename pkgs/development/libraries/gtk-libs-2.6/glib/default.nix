{stdenv, fetchurl, pkgconfig, gettext, perl}:

assert pkgconfig != null && gettext != null && perl != null;

stdenv.mkDerivation {
  name = "glib-2.6.5";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.6/glib-2.6.5.tar.bz2;
    md5 = "777d2e34a60edad28319207b576cda91";
  };
  buildInputs = [pkgconfig gettext perl];
}

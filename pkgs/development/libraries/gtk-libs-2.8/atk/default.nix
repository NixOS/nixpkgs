{stdenv, fetchurl, pkgconfig, glib, perl}:

assert pkgconfig != null && glib != null && perl != null;

stdenv.mkDerivation {
  name = "atk-1.10.3";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.8/atk-1.10.3.tar.bz2;
    md5 = "c84a01fea567b365c0d44b227fead948";
  };
  buildInputs = [pkgconfig perl];
  propagatedBuildInputs = [glib];
}

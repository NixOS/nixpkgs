{stdenv, fetchurl, pkgconfig, glib, perl}:

assert pkgconfig != null && glib != null && perl != null;

stdenv.mkDerivation {
  name = "atk-1.6.0";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.4/atk-1.6.0.tar.bz2;
    md5 = "5e699af22a934ea3c1c1ed3742da0500";
  };
  buildInputs = [pkgconfig perl];
  propagatedBuildInputs = [glib];
}

{stdenv, fetchurl, pkgconfig, glib, perl}:

assert pkgconfig != null && glib != null && perl != null;

stdenv.mkDerivation {
  name = "atk-1.10.1";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.8/atk-1.10.1.tar.bz2;
    md5 = "29df8fe9016083e7eaf129bdd65d8402";
  };
  buildInputs = [pkgconfig perl];
  propagatedBuildInputs = [glib];
}

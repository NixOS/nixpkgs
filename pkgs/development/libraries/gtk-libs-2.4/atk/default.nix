{stdenv, fetchurl, pkgconfig, glib, perl}:

assert pkgconfig != null && glib != null && perl != null;

stdenv.mkDerivation {
  name = "atk-1.6.1";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.4/atk-1.6.1.tar.bz2;
    md5 = "f77be7e128c957bd3056c2e270b5f283";
  };
  buildInputs = [pkgconfig perl];
  propagatedBuildInputs = [glib];
}

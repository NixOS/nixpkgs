{stdenv, fetchurl, pkgconfig, x11, glib}:

assert pkgconfig != null && x11 != null && glib != null;
assert x11.buildClientLibs;

stdenv.mkDerivation {
  name = "pango-1.4.1";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.4/pango-1.4.1.tar.bz2;
    md5 = "39868e0da250fd4c00b2970e4eb84389";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [x11 glib];
}

{stdenv, fetchurl, pkgconfig, x11, glib}:

assert pkgconfig != null && x11 != null && glib != null;
assert x11.buildClientLibs;

stdenv.mkDerivation {
  name = "pango-1.8.2";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.6/pango-1.8.2.tar.bz2;
    md5 = "f5b5da7a173f0566d8217ec112fde993";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [x11 glib];
}

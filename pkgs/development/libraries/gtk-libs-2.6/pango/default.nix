{stdenv, fetchurl, pkgconfig, x11, glib}:

assert pkgconfig != null && x11 != null && glib != null;
assert x11.buildClientLibs;

stdenv.mkDerivation {
  name = "pango-1.8.1";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.6/pango-1.8.1.tar.bz2;
    md5 = "88aa6bf1876766db6864f3b93577887c";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [x11 glib];
}

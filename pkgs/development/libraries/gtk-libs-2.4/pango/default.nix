{stdenv, fetchurl, pkgconfig, x11, glib}:

assert pkgconfig != null && x11 != null && glib != null;
assert x11.buildClientLibs;

stdenv.mkDerivation {
  name = "pango-1.4.0";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.4/pango-1.4.0.tar.bz2;
    md5 = "9b5d9a5dcce5b3899d401f9c2cd6873f";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [x11 glib];
}

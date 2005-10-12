{stdenv, fetchurl, pkgconfig, x11, glib, cairo}:

assert x11.buildClientLibs;

stdenv.mkDerivation {
  name = "pango-1.10.1";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.8/pango-1.10.1.tar.bz2;
    md5 = "1ff4c96982f61ea6f390d09a4febdf18";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [x11 glib cairo];
}

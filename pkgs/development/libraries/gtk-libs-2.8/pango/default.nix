{stdenv, fetchurl, pkgconfig, x11, glib, cairo}:

assert x11.buildClientLibs;

stdenv.mkDerivation {
  name = "pango-1.10.4";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.8/pango-1.10.4.tar.bz2;
    md5 = "d7eeb0f995a93534be8e7c687b465a0c";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [x11 glib cairo];
}

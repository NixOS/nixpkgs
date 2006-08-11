{stdenv, fetchurl, pkgconfig, x11, glib, cairo}:

assert x11.buildClientLibs;

stdenv.mkDerivation {
  name = "pango-1.12.3";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.10/pango-1.12.3.tar.bz2;
    md5 = "c8178e11a895166d86990bb2c38d831b";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [x11 glib cairo];
}

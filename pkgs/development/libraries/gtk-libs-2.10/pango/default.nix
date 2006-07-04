{stdenv, fetchurl, pkgconfig, x11, glib, cairo, libpng}:

assert x11.buildClientLibs;

stdenv.mkDerivation {
  name = "pango-1.13.2";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.11/pango-1.13.2.tar.gz;
    md5 = "17d78473c05fece044c6a3b44519b61f";
  };
  buildInputs = [pkgconfig libpng];
  propagatedBuildInputs = [x11 glib cairo];
}

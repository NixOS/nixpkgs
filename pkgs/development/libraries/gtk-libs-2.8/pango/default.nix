{stdenv, fetchurl, pkgconfig, x11, glib, cairo}:

assert x11.buildClientLibs;

stdenv.mkDerivation {
  name = "pango-1.10.2";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.8/pango-1.10.2.tar.bz2;
    md5 = "7302220d93ac17d2c44f356d852e81dc";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [x11 glib cairo];
}

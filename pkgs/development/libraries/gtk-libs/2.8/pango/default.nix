{stdenv, fetchurl, pkgconfig, x11, glib, cairo}:

assert x11.buildClientLibs;

stdenv.mkDerivation {
  name = "pango-1.12.4";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/pango/1.12/pango-1.12.4.tar.bz2;
    md5 = "8f6749fe961e41dbeed72d1efcd55224";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [x11 glib cairo];
}

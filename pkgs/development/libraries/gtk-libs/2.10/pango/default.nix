{stdenv, fetchurl, pkgconfig, x11, glib, cairo, libpng}:

assert x11.buildClientLibs;

stdenv.mkDerivation {
  name = "pango-1.14.10";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/pango/1.14/pango-1.14.10.tar.bz2;
    md5 = "e9fc2f8168e74e2fa0aa8238ee0e9c06";
  };
  buildInputs = [pkgconfig libpng];
  propagatedBuildInputs = [x11 glib cairo];
}

{stdenv, fetchurl, pkgconfig, libxml2, gnutls, libproxy, sqlite, curl, glib, GConf}:

stdenv.mkDerivation {
  name = "libsoup-2.27.4";
  src = fetchurl {
    url = mirror://gnome/desktop/2.27/2.27.4/sources/libsoup-2.27.4.tar.bz2;
    sha256 = "4d67aa8d2d3c719b67bde58ca3b8a94aa1d172bc242672401d7f3d22685065b9";
  };
  buildInputs = [ pkgconfig libxml2 gnutls libproxy sqlite curl glib GConf ];
}

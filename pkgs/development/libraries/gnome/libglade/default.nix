{stdenv, fetchurl, pkgconfig, gtk, libxml2}:

assert pkgconfig != null && gtk != null && libxml2 != null;

stdenv.mkDerivation {
  name = "libglade-2.0.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/desktop/2.4/2.4.1/sources/libglade-2.0.1.tar.bz2;
    md5 = "4d93f6b01510013ae429e91af432cfe2";
  };
  pkgconfig = pkgconfig;
  gtk = gtk;
  libxml2 = libxml2;
}

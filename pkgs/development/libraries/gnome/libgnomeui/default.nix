{ stdenv, fetchurl, pkgconfig, libgnome, libgnomecanvas, libbonoboui, libglade }:

assert !isNull pkgconfig && !isNull libgnome && !isNull libgnomecanvas
  && !isNull libbonoboui && !isNull libglade;

derivation {
  name = "libgnomeui-2.4.0.1";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/desktop/2.4/2.4.1/sources/libgnomeui-2.4.0.1.tar.bz2;
    md5 = "196f4a3f1f4a531ff57acaa879e98dd2";
  };
  stdenv = stdenv;
  pkgconfig = pkgconfig;
  libgnome = libgnome;
  libgnomecanvas = libgnomecanvas;
  libbonoboui = libbonoboui;
  libglade = libglade;
}

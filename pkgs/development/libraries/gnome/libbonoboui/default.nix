{stdenv, fetchurl, pkgconfig, perl, libxml2, libglade, libgnome
, libgnomecanvas}:

assert pkgconfig != null && perl != null && libxml2 != null
  && libglade != null && libgnome != null && libgnomecanvas != null;

derivation {
  name = "libbonoboui-2.4.1";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/desktop/2.4/2.4.1/sources/libbonoboui-2.4.1.tar.bz2;
    md5 = "943a2d0e9fc7b9f0e97ba869de0c5f2a";
  };
  stdenv = stdenv;
  pkgconfig = pkgconfig;
  perl = perl;
  libxml2 = libxml2;
  libglade = libglade;
  libgnome = libgnome;
  libgnomecanvas = libgnomecanvas;
}

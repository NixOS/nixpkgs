{ stdenv, fetchurl, pkgconfig, perl, glib, libxml2, GConf
, libbonobo, gnomemimedata, popt, bzip2 }:

assert pkgconfig != null && perl != null && glib != null
  && libxml2 != null && GConf != null && libbonobo != null
  && gnomemimedata != null && bzip2 != null;

derivation {
  name = "gnome-vfs-2.4.1";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.gnome.org/pub/gnome/sources/gnome-vfs/2.4/gnome-vfs-2.4.1.tar.bz2;
    md5 = "cb7a36076f6a65e40c7f540be3057310";
  };
  stdenv = stdenv;
  pkgconfig = pkgconfig;
  perl = perl;
  glib = glib;
  libxml2 = libxml2;
  GConf = GConf;
  libbonobo = libbonobo;
  gnomemimedata = gnomemimedata;
  popt = popt;
  bzip2 = bzip2;
}

{stdenv, fetchurl, pkgconfig, perl, glib, gtk, libxml2, ORBit2, popt}:

assert !isNull pkgconfig && !isNull perl
  && !isNull glib && !isNull gtk
  && !isNull libxml2 && !isNull ORBit2 && !isNull popt;

derivation {
  name = "GConf-2.4.0.1";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/desktop/2.4/2.4.1/sources/GConf-2.4.0.1.tar.bz2;
    md5 = "2f7548d0bad24d7c4beba54d0ec98a20";
  };
  stdenv = stdenv;
  pkgconfig = pkgconfig;
  perl = perl; # Perl is not `supposed' to be required, but it is.
  glib = glib;
  gtk = gtk;
  libxml2 = libxml2;
  ORBit2 = ORBit2;
  popt = popt;
}

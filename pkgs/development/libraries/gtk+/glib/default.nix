{stdenv, fetchurl, pkgconfig, gettext, perl}:

assert pkgconfig != null && gettext != null && perl != null;

derivation {
  name = "glib-2.2.3";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.2/glib-2.2.3.tar.bz2;
    md5 = "aa214a10d873b68ddd67cd9de2ccae55";
  };
  stdenv = stdenv;
  pkgconfig = pkgconfig;
  gettext = gettext;
  perl = perl;
}

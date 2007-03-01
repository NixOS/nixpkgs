# gnome-keyring

{input, stdenv, fetchurl, pkgconfig, glib, gtk, perl, perlXMLParser, gettext}:

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [pkgconfig gtk glib perl perlXMLParser gettext];
  CFLAGS = "-DENABLE_NLS=0";
}

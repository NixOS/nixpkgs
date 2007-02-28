# gnome-keyring

{input, stdenv, fetchurl, pkgconfig, glib, gtk}:

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [pkgconfig gtk glib];
  CFLAGS = "-DENABLE_NLS=0";
}

{stdenv, fetchurl, pkgconfig, mono, gtksharp, gtk, monoDLLFixer}:

stdenv.mkDerivation {
  name = "gtkmozembed-sharp-0.7-pre41601";

  builder = ./builder.sh;
  src = /home/eelco/gtkmozembed-sharp-0.7-pre41601.tar.bz2;

  buildInputs = [
    pkgconfig mono gtksharp gtk
  ];

  inherit monoDLLFixer;
}

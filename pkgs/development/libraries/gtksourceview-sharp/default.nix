{stdenv, fetchurl, pkgconfig, mono, gtksharp, gtksourceview, monoDLLFixer}:

stdenv.mkDerivation {
  name = "gtksourceview-sharp-0.6-pre40261";

  builder = ./builder.sh;
  src = /home/eelco/gtksourceview-sharp-0.6-pre40261.tar.bz2;

  patches = [ ./prefix.patch ];

  buildInputs = [
    pkgconfig mono gtksharp gtksourceview
  ];

  inherit monoDLLFixer;
}

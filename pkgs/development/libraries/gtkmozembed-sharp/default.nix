{stdenv, fetchurl, pkgconfig, mono, gtksharp, gtk, monoDLLFixer}:

stdenv.mkDerivation {
  name = "gtkmozembed-sharp-0.7-pre41601";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://losser.labs.cs.uu.nl/~eelco/mono-tmp/gtkmozembed-sharp-0.7-pre41601.tar.bz2;
    md5 = "34aac139377296791acf3af9b5dc27ed";
  };

  buildInputs = [
    pkgconfig mono gtksharp gtk
  ];

  inherit monoDLLFixer;
}

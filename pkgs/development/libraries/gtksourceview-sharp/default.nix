{stdenv, fetchurl, pkgconfig, mono, gtksharp, gtksourceview, monoDLLFixer}:

stdenv.mkDerivation {
  name = "gtksourceview-sharp-0.5";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.go-mono.com/archive/1.0/gtksourceview-sharp-0.5.tar.gz;
    md5 = "b82e767e42a542e185a534048db3078d";
  };

  patches = [ ./prefix.patch ];

  buildInputs = [
    pkgconfig mono gtksharp gtksourceview
  ];

  inherit monoDLLFixer;
}

{stdenv, fetchurl, pkgconfig, mono, gtksharp, gtk, monoDLLFixer}:

stdenv.mkDerivation {
  name = "gecko-sharp-0.5";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.go-mono.com/archive/1.0/gecko-sharp-0.5.tar.gz;
    md5 = "71e75186b2ee5c644d5dd1560ce27357";
  };

  buildInputs = [
    pkgconfig mono gtksharp gtk
  ];

  inherit monoDLLFixer;
}

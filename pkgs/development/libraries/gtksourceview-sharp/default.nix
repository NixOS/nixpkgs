{stdenv, fetchurl, pkgconfig, mono, gtksharp, gtksourceview, monoDLLFixer}:

stdenv.mkDerivation {
  name = "gtksourceview-sharp-0.6-pre40261";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://nixos.org/tarballs/gtksourceview-sharp-0.6-pre40261.tar.bz2;
    md5 = "8bc26c182bd897f50988e110a9a11f34";
  };

  patches = [ ./prefix.patch ];

  buildInputs = [
    pkgconfig mono gtksharp gtksourceview
  ];

  inherit monoDLLFixer;
}

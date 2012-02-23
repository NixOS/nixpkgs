{stdenv, fetchurl, yacc, flex, pkgconfig, glib, xz}:

stdenv.mkDerivation rec {
  name = "vala-0.14.2";

  src = fetchurl {
    url = mirror://gnome/sources/vala/0.14/vala-0.14.2.tar.xz;
    sha256 = "1l5kllw9vpwv24lzv9fp64l3sad46wpxgvsgryrwlrjg91w6jzl0";
  };

  buildNativeInputs = [ yacc flex pkgconfig xz ];

  buildInputs = [ glib ];

  meta = {
    description = "Compiler for the GObject type system";
    homepage = "http://live.gnome.org/Vala";
  };
}

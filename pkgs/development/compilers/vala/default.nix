{stdenv, fetchurl, yacc, flex, pkgconfig, glib}:

stdenv.mkDerivation rec {
  name = "vala-0.9.2";
  src = fetchurl {
    url = "mirror://gnome/sources/vala/0.9/vala-0.9.2.tar.bz2";
    sha256 = "079wsdzb7dlp5kfprvjlhdd0d34jshdn3c7qbngr4qq6g4jf5q92";
  };
  buildInputs = [ yacc flex glib pkgconfig ];
  meta = {
    description = "Compiler for the GObject type system";
    homepage = "http://live.gnome.org/Vala";
  };
}

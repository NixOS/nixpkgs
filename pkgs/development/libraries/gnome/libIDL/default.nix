{stdenv, fetchurl, pkgconfig, glib, lex, yacc}:

assert pkgconfig != null && glib != null && lex != null && yacc != null;

stdenv.mkDerivation {
  name = "libIDL-0.8.2";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/libIDL-0.8.2.tar.bz2;
    md5 = "a75d2dbf3a3c66b567047c94245f8b82";
  };
  buildInputs = [pkgconfig glib lex yacc];
}

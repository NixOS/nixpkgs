{input, stdenv, fetchurl, pkgconfig, glib, lex, yacc}:

assert pkgconfig != null && glib != null && lex != null && yacc != null;

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [pkgconfig glib lex yacc];
}

{stdenv, fetchurl, pkgconfig, glib, lex, yacc}:

assert pkgconfig != null && glib != null && lex != null && yacc != null;

stdenv.mkDerivation {
  name = "libIDL-0.8.2";
  src = fetchurl {
    url = ftp://ftp.gnome.org/pub/gnome/sources/libIDL/0.8/libIDL-0.8.2.tar.bz2;
    md5 = "a75d2dbf3a3c66b567047c94245f8b82";
  };
  buildInputs = [pkgconfig glib lex yacc];
}

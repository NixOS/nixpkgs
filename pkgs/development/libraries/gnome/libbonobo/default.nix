{stdenv, fetchurl, pkgconfig, perl, ORBit2, libxml2, popt, yacc, flex}:

assert !isNull pkgconfig && !isNull perl && !isNull ORBit2
  && !isNull libxml2 && !isNull popt && !isNull yacc && !isNull flex;

derivation {
  name = "libbonobo-2.4.2";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.gnome.org/pub/gnome/sources/libbonobo/2.4/libbonobo-2.4.2.tar.bz2;
    md5 = "78200cc6ed588c93f0d29177a5f3e003";
  };
  stdenv = stdenv;
  pkgconfig = pkgconfig;
  perl = perl;
  ORBit2 = ORBit2;
  libxml2 = libxml2;
  popt = popt;
  yacc = yacc;
  flex = flex;
}

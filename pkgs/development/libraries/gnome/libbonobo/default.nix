{stdenv, fetchurl, pkgconfig, perl, ORBit2, libxml2, popt, yacc, flex}:

assert pkgconfig != null && perl != null && ORBit2 != null
  && libxml2 != null && popt != null && yacc != null && flex != null;

stdenv.mkDerivation {
  name = "libbonobo-2.4.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.gnome.org/pub/gnome/sources/libbonobo/2.4/libbonobo-2.4.2.tar.bz2;
    md5 = "78200cc6ed588c93f0d29177a5f3e003";
  };
  pkgconfig = pkgconfig;
  perl = perl;
  ORBit2 = ORBit2;
  libxml2 = libxml2;
  popt = popt;
  yacc = yacc;
  flex = flex;
}

{ input, stdenv, fetchurl, pkgconfig, perl, perlXMLParser, glib, gtk
, libgnomeui, scrollkeeper, libjpeg
}:

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [pkgconfig perl gtk glib libgnomeui scrollkeeper libjpeg];
  PERL5LIB = perlXMLParser ~ "/lib/site_perl"; # !!!
}

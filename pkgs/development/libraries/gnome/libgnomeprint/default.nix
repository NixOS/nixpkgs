{input, stdenv, fetchurl, perl, perlXMLParser, pkgconfig, glib, pango, libart, libxml2, popt}:

stdenv.mkDerivation {
  inherit (input) name src;

  buildInputs = [
      perl perlXMLParser pkgconfig popt libxml2
      glib pango libart
    ];

  propagatedBuildInputs = [libxml2];  

  PERL5LIB = perlXMLParser ~ "/lib/site_perl";
}

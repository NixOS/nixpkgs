{input, stdenv, fetchurl, perl, perlXMLParser, pkgconfig, gtk, gail, libxml2}:

assert
     null != pkgconfig
  && null != perl
  && null != perlXMLParser
  ;

stdenv.mkDerivation {
  inherit (input) name src;

  buildInputs = [
      perl perlXMLParser pkgconfig gtk libxml2 gail
    ];

  PERL5LIB = perlXMLParser ~ "/lib/site_perl";
}


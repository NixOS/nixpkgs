{input, stdenv, fetchurl, pkgconfig, perl, perlXMLParser}:

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [pkgconfig perl perlXMLParser];
  PERL5LIB = perlXMLParser ~ "/lib/site_perl";
}

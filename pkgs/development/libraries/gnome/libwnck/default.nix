{input, stdenv, fetchurl, pkgconfig, gtk}:

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [pkgconfig gtk];
#  PERL5LIB = perlXMLParser ~ "/lib/site_perl"; # !!!
}

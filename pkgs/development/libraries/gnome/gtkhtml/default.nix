{input, stdenv, fetchurl, perl, perlXMLParser, pkgconfig, atk, gail, gtk,
  libgnomeprint, libgnomeprintui, libgnomeui, libglade, gnomeicontheme, libjpeg}:

# TODO build complains about missing libsoup and soup. Optional dependency?

assert
     null != pkgconfig
  && null != perl
  && null != perlXMLParser
  && null != pkgconfig
  && null != atk
  && null != gail
  && null != gtk
  ;

stdenv.mkDerivation {
  inherit (input) name src;

  buildInputs = [
      perl perlXMLParser pkgconfig libjpeg
      atk gail gtk
      libglade libgnomeprint libgnomeprintui libgnomeui
      gnomeicontheme
    ];

  PERL5LIB = perlXMLParser ~ "/lib/site_perl";
}


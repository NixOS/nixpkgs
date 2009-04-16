{ input, stdenv, fetchurl, perl, perlXMLParser, pkgconfig, atk, gail, gtk
, libgnomeprint, libgnomeprintui, libgnomeui, libglade, gnomeicontheme
, libjpeg, gettext, intltool
}:

# TODO build complains about missing libsoup and soup. Optional dependency?

stdenv.mkDerivation {
  inherit (input) name src;

  buildInputs = [
    perl perlXMLParser pkgconfig libjpeg
    atk gail gtk
    libglade libgnomeprint libgnomeprintui libgnomeui
    gnomeicontheme gettext intltool    
  ];
}


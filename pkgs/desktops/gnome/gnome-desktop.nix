{ input, stdenv, fetchurl, gnome, pkgconfig, perl, perlXMLParser
, libjpeg, gettext, which, python, libxml2Python, libxslt
}:

# !!! should get rid of libxml2Python, see gnomedocutils

stdenv.mkDerivation {
  inherit (input) name src;
  
  buildInputs = [
    pkgconfig perl perlXMLParser gnome.gtk gnome.glib gnome.libgnomeui
    gnome.scrollkeeper libjpeg gnome.gnomedocutils gettext which
    python libxml2Python libxslt    
  ];

  configureFlags = "--disable-scrollkeeper";
}

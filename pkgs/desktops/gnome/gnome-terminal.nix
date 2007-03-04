{ input, stdenv, fetchurl, gnome, pkgconfig, perl, perlXMLParser
, gettext, which, python, libxml2Python, libxslt
}:

# !!! should get rid of libxml2Python, see gnomedocutils

stdenv.mkDerivation {
  inherit (input) name src;
  
  buildInputs = [
    pkgconfig perl perlXMLParser gnome.gtk gnome.GConf gnome.libglade
    gnome.libgnomeui gnome.startupnotification gnome.gnomevfs gnome.vte
    gnome.gnomedocutils gettext which gnome.scrollkeeper
    python libxml2Python libxslt
  ];

  configureFlags = "--disable-scrollkeeper";
}

{ input, stdenv, fetchurl, gnome, pkgconfig, perl, perlXMLParser
, gettext, libxslt, libXmu
#, which, python, libxml2Python, libxslt
}:

# !!! should get rid of libxml2Python, see gnomedocutils

stdenv.mkDerivation {
  inherit (input) name src;
  
  buildInputs = [
    pkgconfig perl perlXMLParser gnome.glib gnome.gtk gnome.libgnome
    gnome.libgnomeui gnome.libglade gnome.libgnomeprintui
    gnome.gnomedesktop gnome.gnomepanel gnome.libgtop gnome.scrollkeeper
    gnome.gnomedocutils gettext libxslt libXmu
    # gnome.gtk gnome.GConf gnome.libglade
    #gnome.libgnomeui gnome.startupnotification gnome.gnomevfs gnome.vte
    #gnome.gnomedocutils gettext which gnome.scrollkeeper
    #python libxml2Python libxslt
  ];

  configureFlags = "--disable-scrollkeeper";
}

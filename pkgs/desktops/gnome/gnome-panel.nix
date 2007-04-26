{ input, stdenv, fetchurl, gnome, pkgconfig, perl, perlXMLParser
, libjpeg, libpng, libXmu, libXau, dbus_glib, gettext, libxslt
}:

stdenv.mkDerivation {
  inherit (input) name src;
  
  buildInputs = [
    pkgconfig perl perlXMLParser gnome.gtk gnome.glib gnome.ORBit2
    gnome.libgnome gnome.libgnomeui gnome.gnomedesktop gnome.libglade
    gnome.libwnck libjpeg libpng gnome.scrollkeeper libXmu libXau
    dbus_glib gnome.gnomemenus gnome.gnomedocutils gettext libxslt
  ];

  configureFlags = "--disable-scrollkeeper";

  preConfigure = "
    mkdir wrapper
    echo \"#! $SHELL\" >> wrapper/xsltproc
    echo \"exec `type -tp xsltproc` --nonet \\\"\\$@\\\"\" >> wrapper/xsltproc
    chmod +x wrapper/xsltproc
    PATH=$(pwd)/wrapper:$PATH
  ";
}

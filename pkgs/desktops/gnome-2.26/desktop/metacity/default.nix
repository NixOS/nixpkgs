{ stdenv, fetchurl, pkgconfig, glib, gtk, libXcomposite, libXcursor, libXdamage
, intltool, GConf, startup_notification, zenity, gnome_doc_utils}:

stdenv.mkDerivation {
  name = "metacity-2.26.0";
  src = fetchurl {
    url = mirror://gnome/desktop/2.26/2.26.2/sources/metacity-2.26.0.tar.bz2;
    sha256 = "0y4hamalbplpsilyfbs1c8za6f7cgp9p4kcswsx67ncr310idfi9";
  };
  buildInputs = [ pkgconfig glib gtk libXcomposite libXcursor libXdamage
                  intltool GConf startup_notification zenity gnome_doc_utils ];
}

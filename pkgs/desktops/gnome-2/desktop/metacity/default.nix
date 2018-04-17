{ stdenv, fetchurl, pkgconfig, glib, gtk, libXcomposite, libXcursor, libXdamage
, libcanberra-gtk2, intltool, GConf, startup_notification, zenity, gnome-doc-utils
, gsettings-desktop-schemas }:

stdenv.mkDerivation {
  name = "metacity-2.30.3";

  src = fetchurl {
    url = mirror://gnome/sources/metacity/2.30/metacity-2.30.3.tar.bz2;
    sha256 = "1p8qzj967mmlwdl6gv9vb2vzs19czvivl0sd337lgr55iw0qgy08";
  };

  buildInputs =
    [ pkgconfig glib gtk libXcomposite libXcursor libXdamage libcanberra-gtk2
      intltool GConf startup_notification zenity gnome-doc-utils
      gsettings-desktop-schemas
    ];
}

{ stdenv, fetchurl, pkgconfig, glib, gtk, libXcomposite, libXcursor, libXdamage
, intltool, GConf, startup_notification, zenity, gnome_doc_utils}:

stdenv.mkDerivation {
  name = "metacity-2.28.0";
  src = fetchurl {
    url = nirror://gnome/sources/metacity/2.28/metacity-2.28.0.tar.bz2;
    sha256 = "0iamb6gw6gl6bfs7nqxpwr9xiij5axxr1iy4bl6g9z11dwx5a886";
  };
  buildInputs = [ pkgconfig glib gtk libXcomposite libXcursor libXdamage
                  intltool GConf startup_notification zenity gnome_doc_utils ];
}

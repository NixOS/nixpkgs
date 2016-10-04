{ stdenv, fetchurl, pkgconfig, intltool, gtk3, gnome3, wrapGAppsHook
, json_glib, qqwing, itstool, libxml2 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = [ pkgconfig intltool wrapGAppsHook gtk3 gnome3.libgee
                  json_glib qqwing itstool libxml2 ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Sudoku;
    description = "Test your logic skills in this number grid puzzle";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

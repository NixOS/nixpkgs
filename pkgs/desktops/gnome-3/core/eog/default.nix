{ fetchurl, stdenv, gettext, pkgconfig, itstool, libxml2, libjpeg, gnome3
, shared_mime_info, wrapGAppsHook, librsvg, libexif }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  nativeBuildInputs = [ pkgconfig gettext itstool wrapGAppsHook ];

  buildInputs = with gnome3;
    [ libxml2 libjpeg gtk glib libpeas librsvg
      gsettings_desktop_schemas shared_mime_info adwaita-icon-theme
      gnome_desktop libexif dconf ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/EyeOfGnome;
    platforms = platforms.linux;
    description = "GNOME image viewer";
    maintainers = gnome3.maintainers;
  };
}

{ fetchurl, stdenv, gettext, pkgconfig, itstool, libxml2, libjpeg, gnome3
, shared-mime-info, wrapGAppsHook, librsvg, libexif, gobjectIntrospection }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  nativeBuildInputs = [ pkgconfig gettext itstool wrapGAppsHook gobjectIntrospection ];

  buildInputs = with gnome3;
    [ libxml2 libjpeg gtk glib libpeas librsvg
      gsettings-desktop-schemas shared-mime-info adwaita-icon-theme
      gnome-desktop libexif dconf ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/EyeOfGnome;
    platforms = platforms.linux;
    description = "GNOME image viewer";
    maintainers = gnome3.maintainers;
  };
}

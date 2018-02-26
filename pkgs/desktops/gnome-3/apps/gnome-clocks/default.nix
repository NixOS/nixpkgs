{ stdenv, fetchurl
, meson, ninja, gettext, pkgconfig, wrapGAppsHook, itstool, desktop-file-utils
, vala,  gtk3, glib, gsound
, gnome3, gdk_pixbuf, geoclue2, libgweather }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  nativeBuildInputs = [
    vala meson ninja pkgconfig gettext itstool wrapGAppsHook desktop-file-utils
  ];
  buildInputs = [
    gtk3 glib gnome3.gsettings-desktop-schemas gdk_pixbuf gnome3.defaultIconTheme
    gnome3.gnome-desktop gnome3.geocode-glib geoclue2 libgweather gsound
  ];

  prePatch = "patchShebangs build-aux/";

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Clocks;
    description = "Clock application designed for GNOME 3";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

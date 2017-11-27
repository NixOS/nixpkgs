{ stdenv, fetchurl
, meson, ninja, gettext, pkgconfig, wrapGAppsHook, itstool, desktop_file_utils
, vala,  gtk3, glib, gsound, libcanberra_gtk3
, gnome3, gdk_pixbuf, geoclue2, libgweather }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  nativeBuildInputs = [ vala meson ninja pkgconfig gettext itstool wrapGAppsHook desktop_file_utils ];
  buildInputs = [ gtk3 glib libcanberra_gtk3
                  gnome3.gsettings_desktop_schemas
                  gdk_pixbuf gnome3.defaultIconTheme
                  gnome3.gnome_desktop gnome3.geocode_glib geoclue2
                  libgweather gsound ];

  enableParallelBuilding = true;

  prePatch = "patchShebangs build-aux/";

  checkPhase = "meson test";

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Clocks;
    description = "Clock application designed for GNOME 3";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

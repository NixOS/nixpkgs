{ stdenv, intltool, fetchurl, pkgconfig, udisks2, libsecret, libdvdread
, bash, gtk3, glib, wrapGAppsHook, cracklib, libnotify
, itstool, gnome3, gdk_pixbuf, libxml2, python
, libcanberra_gtk3, libxslt, libtool, docbook_xsl, libpwquality }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ bash pkgconfig gtk3 glib intltool itstool
                  libxslt libtool libsecret libpwquality cracklib
                  libnotify libdvdread libcanberra_gtk3 docbook_xsl
                  gdk_pixbuf gnome3.defaultIconTheme
                  udisks2 gnome3.gnome_settings_daemon
                  gnome3.gsettings_desktop_schemas wrapGAppsHook libxml2 ];

  meta = with stdenv.lib; {
    homepage = https://en.wikipedia.org/wiki/GNOME_Disks;
    description = "A udisks graphical front-end";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

{ stdenv, gettext, fetchurl, pkgconfig, udisks2, libsecret, libdvdread
, meson, ninja, gtk, glib, wrapGAppsHook, libnotify
, itstool, gnome3, gdk_pixbuf, libxml2
, libcanberra_gtk3, libxslt, docbook_xsl, libpwquality }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  nativeBuildInputs = [ meson ninja pkgconfig gettext itstool libxslt docbook_xsl
                        wrapGAppsHook libxml2 ];
  buildInputs = [ gtk glib libsecret libpwquality libnotify libdvdread libcanberra_gtk3
                  gdk_pixbuf udisks2 gnome3.defaultIconTheme
                  gnome3.gnome_settings_daemon gnome3.gsettings_desktop_schemas ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  meta = with stdenv.lib; {
    homepage = https://en.wikipedia.org/wiki/GNOME_Disks;
    description = "A udisks graphical front-end";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

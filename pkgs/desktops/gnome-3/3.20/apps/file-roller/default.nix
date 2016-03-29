{ stdenv, fetchurl, glib, pkgconfig, gnome3, intltool, itstool, libxml2, libarchive
, attr, bzip2, acl, wrapGAppsHook, librsvg, gdk_pixbuf }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  # TODO: support nautilus
  # it tries to create {nautilus}/lib/nautilus/extensions-3.0/libnautilus-fileroller.so

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  buildInputs = [ glib gnome3.gtk intltool itstool libxml2 libarchive
                  gnome3.defaultIconTheme attr bzip2 acl gdk_pixbuf librsvg
                  gnome3.dconf ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/FileRoller;
    description = "Archive manager for the GNOME desktop environment";
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}

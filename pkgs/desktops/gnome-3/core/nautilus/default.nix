{ stdenv, fetchurl, pkgconfig, libxml2, dbus_glib, shared_mime_info, libexif
, gtk, gnome3, libunique, intltool, gobjectIntrospection, gnome-autoar, glib
, libnotify, wrapGAppsHook, exempi, librsvg, tracker, libselinux, gdk_pixbuf }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  buildInputs = [ libxml2 dbus_glib shared_mime_info libexif gtk libunique intltool exempi librsvg
                  gnome3.gnome_desktop gnome3.adwaita-icon-theme
                  gnome3.gsettings_desktop_schemas gnome3.dconf libnotify tracker libselinux ];

  propagatedBuildInputs = [ gnome-autoar ];

  # fatal error: gio/gunixinputstream.h: No such file or directory
  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  preFixup = ''
    gappsWrapperArgs+=(
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${gdk_pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"
    )
  '';

#  hardeningDisable = [ "format" ];
  enableParallelBuilding = true;

  patches = [ ./extension_dir.patch ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}

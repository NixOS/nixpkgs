{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, libxml2, desktop_file_utils, wrapGAppsHook
, gtk, gnome3, gnome-autoar, glib, dbus_glib, shared_mime_info, libnotify, libexif
, exempi, librsvg, tracker, tracker-miners, libselinux, gdk_pixbuf }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  nativeBuildInputs = [ meson ninja pkgconfig libxml2 gettext wrapGAppsHook desktop_file_utils ];

  buildInputs = [ dbus_glib shared_mime_info libexif gtk exempi libnotify libselinux
                  tracker tracker-miners gnome3.gnome_desktop gnome3.adwaita-icon-theme
                  gnome3.gsettings_desktop_schemas ];

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

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
  '';

  patches = [ ./extension_dir.patch ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}

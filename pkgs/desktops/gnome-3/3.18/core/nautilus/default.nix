{ stdenv, fetchurl, pkgconfig, libxml2, dbus_glib, shared_mime_info, libexif
, gtk, gnome3, libunique, intltool, gobjectIntrospection
, libnotify, makeWrapper, exempi, librsvg, tracker }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = [ pkgconfig libxml2 dbus_glib shared_mime_info libexif gtk libunique intltool exempi librsvg
                  gnome3.gnome_desktop gnome3.adwaita-icon-theme
                  gnome3.gsettings_desktop_schemas libnotify makeWrapper tracker ];

  preFixup = ''
    wrapProgram "$out/bin/nautilus" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$out/share" \
      --suffix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  patches = [ ./extension_dir.patch ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}

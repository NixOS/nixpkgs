{ stdenv, fetchurl, pkgconfig, libxml2, dbus_glib, shared_mime_info, libexif
, gtk, gnome3, libunique, intltool, gobjectIntrospection
, libnotify, makeWrapper, exempi, librsvg, tracker }:

stdenv.mkDerivation rec {
  name = "nautilus-3.12.2";

  src = fetchurl {
    url = "mirror://gnome/sources/nautilus/3.12/${name}.tar.xz";
    sha256 = "969c2bedc324eab7b9399bdb3a7db61f819a2995c733349ded081b059a1cafb1";
  };

  buildInputs = [ pkgconfig libxml2 dbus_glib shared_mime_info libexif gtk libunique intltool exempi librsvg
                  gnome3.gnome_desktop gnome3.gnome_icon_theme gnome3.gnome_icon_theme_symbolic
                  gnome3.gsettings_desktop_schemas libnotify makeWrapper tracker ];

  preFixup = ''
    wrapProgram "$out/bin/nautilus" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$out/share:$GSETTINGS_SCHEMAS_PATH"
  '';

  patches = [ ./extension_dir.patch ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}

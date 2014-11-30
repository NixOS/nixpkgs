{ stdenv, fetchurl, pkgconfig, libxml2, dbus_glib, shared_mime_info, libexif
, gtk, gnome3, libunique, intltool, gobjectIntrospection
, libnotify, makeWrapper, exempi, librsvg, tracker }:

stdenv.mkDerivation rec {
  name = "nautilus-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/nautilus/${gnome3.version}/${name}.tar.xz";
    sha256 = "f7b15bb8a4aa244ad231f235c97f66ac184d96c4ff809798a6256e37addd2bac";
  };

  buildInputs = [ pkgconfig libxml2 dbus_glib shared_mime_info libexif gtk libunique intltool exempi librsvg
                  gnome3.gnome_desktop gnome3.adwaita-icon-theme
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
    maintainers = [ maintainers.lethalman ];
  };
}

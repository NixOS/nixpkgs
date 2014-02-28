{ stdenv, fetchurl, pkgconfig, libxml2, dbus_glib, shared_mime_info, libexif
, gtk, gnome3, libunique, intltool, gobjectIntrospection
, libnotify, makeWrapper, exempi, librsvg }:

stdenv.mkDerivation rec {
  name = "nautilus-3.10.1";

  src = fetchurl {
    url = "mirror://gnome/sources/nautilus/3.10/${name}.tar.xz";
    sha256 = "09y7dxaw4bjgan3q10azky0h6kndqv2lfn75iip12zchf2hk59gn";
  };

  configureFlags = [ "--enable-tracker=no" ];

  buildInputs = [ pkgconfig libxml2 dbus_glib shared_mime_info libexif gtk libunique intltool exempi librsvg
                  gnome3.gnome_desktop gnome3.gnome_icon_theme gnome3.gnome_icon_theme_symbolic gnome3.gsettings_desktop_schemas libnotify makeWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/nautilus" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:${gtk}/share:${gnome3.gnome_icon_theme}:${gnome3.gsettings_desktop_schemas}/share:$out/share"
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}

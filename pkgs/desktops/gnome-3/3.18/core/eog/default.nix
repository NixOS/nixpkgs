{ fetchurl, stdenv, intltool, pkgconfig, itstool, libxml2, libjpeg, gnome3
, shared_mime_info, makeWrapper, librsvg, libexif }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = with gnome3;
    [ intltool pkgconfig itstool libxml2 libjpeg gtk glib libpeas makeWrapper librsvg
      gsettings_desktop_schemas shared_mime_info adwaita-icon-theme gnome_desktop libexif ];

  preFixup = ''
    wrapProgram "$out/bin/eog" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:${shared_mime_info}/share:${gnome3.adwaita-icon-theme}/share:${gnome3.gtk}/share:$out/share:$GSETTINGS_SCHEMAS_PATH"

  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/EyeOfGnome; 
    platforms = platforms.linux;
    description = "GNOME image viewer";
    maintainers = gnome3.maintainers;
  };
}

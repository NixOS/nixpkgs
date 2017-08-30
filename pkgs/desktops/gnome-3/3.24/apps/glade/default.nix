{ stdenv, intltool, fetchurl, python
, pkgconfig, gtk3, glib
, makeWrapper, itstool, libxml2, docbook_xsl
, gnome3, librsvg, gdk_pixbuf, libxslt }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ pkgconfig gtk3 glib intltool itstool libxml2 python
                  gnome3.gsettings_desktop_schemas makeWrapper docbook_xsl
                  gdk_pixbuf gnome3.defaultIconTheme librsvg libxslt ];

  enableParallelBuilding = true;

  preFixup = ''
    wrapProgram "$out/bin/glade" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Glade;
    description = "User interface designer for GTK+ applications";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}

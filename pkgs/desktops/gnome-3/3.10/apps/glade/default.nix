{ stdenv, intltool, fetchurl, python
, pkgconfig, gtk3, glib, hicolor_icon_theme
, makeWrapper, itstool, libxml2, docbook_xsl
, gnome3, librsvg, gdk_pixbuf, libxslt }:

stdenv.mkDerivation rec {
  name = "glade-3.16.1";

  src = fetchurl {
    url = "mirror://gnome/sources/glade/3.16/${name}.tar.xz";
    sha256 = "994ac258bc100d3907ed40a2880c3144f13997b324477253e812d59f2716523f";
  };

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ pkgconfig gtk3 glib intltool itstool libxml2 python
                  gnome3.gsettings_desktop_schemas makeWrapper docbook_xsl
                  gdk_pixbuf gnome3.gnome_icon_theme librsvg libxslt
                  hicolor_icon_theme gnome3.gnome_icon_theme_symbolic ];

  enableParallelBuilding = true;

  preFixup = ''
    wrapProgram "$out/bin/glade" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
    rm $out/share/icons/hicolor/icon-theme.cache
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Glade;
    description = "User interface designer for GTK+ applications";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}

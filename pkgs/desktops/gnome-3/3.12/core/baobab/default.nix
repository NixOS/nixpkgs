{ stdenv, intltool, fetchurl, vala, libgtop
, pkgconfig, gtk3, glib, hicolor_icon_theme
, bash, makeWrapper, itstool, libxml2
, gnome3, librsvg, gdk_pixbuf, file }:

stdenv.mkDerivation rec {
  name = "baobab-3.12.1";

  src = fetchurl {
    url = "mirror://gnome/sources/baobab/3.12/${name}.tar.xz";
    sha256 = "494808d8a5b1776377749a1dcd5b251eb399208a4c90380dc8b8c789811e514c";
  };

  doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];
  propagatedBuildInputs = [ gdk_pixbuf gnome3.gnome_icon_theme librsvg
                            hicolor_icon_theme gnome3.gnome_icon_theme_symbolic ];

  buildInputs = [ vala pkgconfig gtk3 glib libgtop intltool itstool libxml2
                  gnome3.gsettings_desktop_schemas makeWrapper file
                  gdk_pixbuf gnome3.gnome_icon_theme librsvg
                  hicolor_icon_theme gnome3.gnome_icon_theme_symbolic ];

  preFixup = ''
    rm $out/share/icons/hicolor/icon-theme.cache
    rm $out/share/icons/HighContrast/icon-theme.cache
    wrapProgram "$out/bin/baobab" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Baobab;
    description = "Graphical application to analyse disk usage in any Gnome environment";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

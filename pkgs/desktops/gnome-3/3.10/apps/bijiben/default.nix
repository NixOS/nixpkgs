{ stdenv, intltool, fetchurl, pkgconfig, glib
, hicolor_icon_theme, makeWrapper, itstool
, clutter_gtk, libuuid, webkitgtk, zeitgeist
, gnome3, librsvg, gdk_pixbuf, libxml2 }:

stdenv.mkDerivation rec {
  name = "bijiben-3.10.2";

  src = fetchurl {
    url = "mirror://gnome/sources/bijiben/3.10/${name}.tar.xz";
    sha256 = "81257f85218968b0ad386da6e1143586de478870ca74bb5387646a479999a7d4";
  };

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ pkgconfig glib intltool itstool libxml2
                  clutter_gtk libuuid webkitgtk gnome3.tracker
                  gnome3.gnome_online_accounts zeitgeist
                  gnome3.gsettings_desktop_schemas makeWrapper
                  gdk_pixbuf gnome3.gnome_icon_theme librsvg
                  hicolor_icon_theme gnome3.gnome_icon_theme_symbolic ];

  enableParallelBuilding = true;

  preFixup = ''
    wrapProgram "$out/bin/bijiben" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
    rm $out/share/icons/hicolor/icon-theme.cache
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Bijiben;
    description = "Note editor designed to remain simple to use";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}

{ stdenv, intltool, fetchurl, pkgconfig, glib
, evolution_data_server, evolution
, hicolor_icon_theme, makeWrapper, itstool, desktop_file_utils
, clutter_gtk, libuuid, webkitgtk, zeitgeist
, gnome3, librsvg, gdk_pixbuf, libxml2 }:

stdenv.mkDerivation rec {
  name = "bijiben-${gnome3.version}.2";

  src = fetchurl {
    url = "mirror://gnome/sources/bijiben/${gnome3.version}/${name}.tar.xz";
    sha256 = "7998632c83889071c23725ad95867618c72814676a3a3865881e9556714e0537";
  };

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ pkgconfig glib intltool itstool libxml2
                  clutter_gtk libuuid webkitgtk gnome3.tracker
                  gnome3.gnome_online_accounts zeitgeist desktop_file_utils
                  gnome3.gsettings_desktop_schemas makeWrapper
                  gdk_pixbuf gnome3.adwaita-icon-theme librsvg
                  evolution_data_server evolution
                  hicolor_icon_theme gnome3.adwaita-icon-theme ];

  enableParallelBuilding = true;

  preFixup = ''
    wrapProgram "$out/bin/bijiben" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Bijiben;
    description = "Note editor designed to remain simple to use";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}

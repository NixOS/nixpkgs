{ stdenv, intltool, fetchurl, pkgconfig
, bash, gtk3, glib, hicolor_icon_theme, makeWrapper
, itstool, gnome3, librsvg, gdk_pixbuf, libxml2 }:

stdenv.mkDerivation rec {
  name = "gnome-system-log-3.9.90";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-system-log/3.9/${name}.tar.xz";
    sha256 = "9eeb51982d347aa7b33703031e2c1d8084201374665425cd62199649b29a5411";
  };

  doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];
  propagatedBuildInputs = [ gdk_pixbuf gnome3.gnome_icon_theme librsvg
                            hicolor_icon_theme gnome3.gnome_icon_theme_symbolic ];

  buildInputs = [ bash pkgconfig gtk3 glib intltool itstool
                  gnome3.gsettings_desktop_schemas makeWrapper libxml2 ];

  preFixup = ''
    wrapProgram "$out/bin/gnome-system-log" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share:${gnome3.gnome_themes_standard}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
    rm $out/share/icons/hicolor/icon-theme.cache
  '';

  meta = with stdenv.lib; {
    homepage = https://help.gnome.org/users/gnome-system-log/3.9/;
    description = "Graphical, menu-driven viewer that you can use to view and monitor your system logs";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

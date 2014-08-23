{ stdenv, intltool, fetchurl, pkgconfig, gtkmm3, libxml2
, bash, gtk3, glib, hicolor_icon_theme, makeWrapper
, itstool, gnome3, librsvg, gdk_pixbuf, libgtop }:

stdenv.mkDerivation rec {
  name = "gnome-system-monitor-3.10.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-system-monitor/3.10/${name}.tar.xz";
    sha256 = "bd009e15672afe4ad3ebd7ed286cce79b9f76420fd39bc77a5826b29134b9db0";
  };

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];
  propagatedBuildInputs = [ gdk_pixbuf gnome3.gnome_icon_theme librsvg
                            hicolor_icon_theme gnome3.gnome_icon_theme_symbolic ];

  buildInputs = [ bash pkgconfig gtk3 glib intltool itstool libxml2
                  gtkmm3 libgtop makeWrapper
                  gnome3.gsettings_desktop_schemas ];

  preFixup = ''
    wrapProgram "$out/bin/gnome-system-monitor" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share:${gnome3.gnome_themes_standard}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://help.gnome.org/users/gnome-system-monitor/3.10/;
    description = "System Monitor shows you what programs are running and how much processor time, memory, and disk space are being used";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

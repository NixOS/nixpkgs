{ stdenv, intltool, fetchurl, pkgconfig, gtkmm3, libxml2
, bash, gtk3, glib, makeWrapper
, itstool, gnome3, librsvg, gdk_pixbuf, libgtop }:

stdenv.mkDerivation rec {
  name = "gnome-system-monitor-${gnome3.version}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-system-monitor/${gnome3.version}/${name}.tar.xz";
    sha256 = "14akcz4dwjnfx47gncyavjr82zc78a912v5gdp6h3z19bn5nx4q0";
  };

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ bash pkgconfig gtk3 glib intltool itstool libxml2
                  gtkmm3 libgtop makeWrapper
                  gdk_pixbuf gnome3.defaultIconTheme librsvg
                  gnome3.gsettings_desktop_schemas ];

  preFixup = ''
    wrapProgram "$out/bin/gnome-system-monitor" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://help.gnome.org/users/gnome-system-monitor/3.12/;
    description = "System Monitor shows you what programs are running and how much processor time, memory, and disk space are being used";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

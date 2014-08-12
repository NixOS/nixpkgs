{ stdenv, intltool, fetchurl, pkgconfig, gtkmm3, libxml2
, bash, gtk3, glib, hicolor_icon_theme, makeWrapper
, itstool, gnome3, librsvg, gdk_pixbuf, libgtop }:

stdenv.mkDerivation rec {
  name = "gnome-system-monitor-3.12.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-system-monitor/3.12/${name}.tar.xz";
    sha256 = "ba074e2157302d91d73b68e13207bf85452b84234e429b1ec9b9a7b1c70736d8";
  };

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];
  propagatedBuildInputs = [  ];

  buildInputs = [ bash pkgconfig gtk3 glib intltool itstool libxml2
                  gtkmm3 libgtop makeWrapper
                  gdk_pixbuf gnome3.gnome_icon_theme librsvg
                  hicolor_icon_theme gnome3.gnome_icon_theme_symbolic
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
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

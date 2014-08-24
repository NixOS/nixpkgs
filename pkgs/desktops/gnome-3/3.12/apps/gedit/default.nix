{ stdenv, intltool, fetchurl, enchant, isocodes
, pkgconfig, gtk3, glib, hicolor_icon_theme
, bash, makeWrapper, itstool, libsoup, libxml2
, gnome3, librsvg, gdk_pixbuf, file }:

stdenv.mkDerivation rec {
  name = "gedit-3.12.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gedit/3.12/${name}.tar.xz";
    sha256 = "8e3edc62102934a8be708b0fdf27b86368fa9ede885628283bf8e91b26bbb67f";
  };

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ pkgconfig gtk3 glib intltool itstool enchant isocodes
                  gdk_pixbuf gnome3.gnome_icon_theme librsvg libsoup
                  gnome3.libpeas gnome3.gtksourceview libxml2
                  hicolor_icon_theme gnome3.gnome_icon_theme_symbolic
                  gnome3.gsettings_desktop_schemas makeWrapper file ];

  enableParallelBuilding = true;

  preFixup = ''
    wrapProgram "$out/bin/gedit" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix LD_LIBRARY_PATH : "${gnome3.libpeas}/lib:${gnome3.gtksourceview}/lib" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Gedit;
    description = "Official text editor of the GNOME desktop environment";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

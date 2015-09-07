{ stdenv, intltool, fetchurl, enchant, isocodes
, pkgconfig, gtk3, glib
, bash, makeWrapper, itstool, libsoup, libxml2
, gnome3, librsvg, gdk_pixbuf, file }:

stdenv.mkDerivation rec {
  name = "gedit-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gedit/${gnome3.version}/${name}.tar.xz";
    sha256 = "0bs0vf773l0k7f4zxqlyb8z772s5dcn7ww0073hs7z3hj0l3lzrc";
  };

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ pkgconfig gtk3 glib intltool itstool enchant isocodes
                  gdk_pixbuf gnome3.defaultIconTheme librsvg libsoup
                  gnome3.libpeas gnome3.gtksourceview libxml2
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
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

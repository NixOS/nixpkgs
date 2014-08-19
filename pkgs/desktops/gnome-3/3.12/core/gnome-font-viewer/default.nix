{ stdenv, intltool, fetchurl
, pkgconfig, gtk3, glib, hicolor_icon_theme
, bash, makeWrapper, itstool
, gnome3, librsvg, gdk_pixbuf }:

stdenv.mkDerivation rec {
  name = "gnome-font-viewer-3.12.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-font-viewer/3.12/${name}.tar.xz";
    sha256 = "fca50711b7bd4edd1213dd4f05a309911cd1e832974142944c06d52ae07cbe45";
  };

  doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ pkgconfig gtk3 glib intltool itstool gnome3.gnome_desktop
                  gdk_pixbuf gnome3.gnome_icon_theme librsvg
                  hicolor_icon_theme gnome3.gnome_icon_theme_symbolic
                  gnome3.gsettings_desktop_schemas makeWrapper ];

  preFixup = ''
    wrapProgram "$out/bin/gnome-font-viewer" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    description = "Program that can preview fonts and create thumbnails for fonts";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

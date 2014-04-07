{ stdenv, intltool, fetchurl
, pkgconfig, gtk3, glib, hicolor_icon_theme
, bash, makeWrapper, itstool
, gnome3, librsvg, gdk_pixbuf }:

stdenv.mkDerivation rec {
  name = "gnome-font-viewer-3.10.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-font-viewer/3.10/${name}.tar.xz";
    sha256 = "3928350f58ac6c95f44b64cba1a5f03437b19d9b2645a7b01176067504fdd652";
  };

  doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];
  propagatedBuildInputs = [ gdk_pixbuf gnome3.gnome_icon_theme librsvg
                            hicolor_icon_theme gnome3.gnome_icon_theme_symbolic ];

  buildInputs = [ pkgconfig gtk3 glib intltool itstool gnome3.gnome_desktop
                  gnome3.gsettings_desktop_schemas makeWrapper ];

  preFixup = ''
    wrapProgram "$out/bin/gnome-font-viewer" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share:${gnome3.gnome_themes_standard}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    description = "Program that can preview fonts and create thumbnails for fonts";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

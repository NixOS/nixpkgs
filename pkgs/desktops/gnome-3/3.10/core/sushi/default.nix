{ stdenv, fetchurl, pkgconfig, file, intltool, gobjectIntrospection, glib
, clutter_gtk, clutter-gst, gnome3, gtksourceview, libmusicbrainz
, webkitgtk, libmusicbrainz5, icu, makeWrapper, gst_all_1
, gdk_pixbuf, librsvg, hicolor_icon_theme }:

stdenv.mkDerivation rec {
  name = "sushi-3.10.0";

  src = fetchurl {
    url = "mirror://gnome/sources/sushi/3.10/${name}.tar.xz";
    sha256 = "cffcf28b170f5825e84983a979972d4d901a453b61cbe3e560d362e8dd4b4bc8";
  };

  propagatedUserEnvPkgs = [ gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good ];

  buildInputs = [ pkgconfig file intltool gobjectIntrospection glib
                  clutter_gtk clutter-gst gnome3.gjs gtksourceview gdk_pixbuf librsvg
                  gnome3.gnome_icon_theme hicolor_icon_theme gnome3.gnome_icon_theme_symbolic
                  libmusicbrainz5 webkitgtk gnome3.evince icu makeWrapper ];

  enableParallelBuilding = true;

  preFixup = ''
    wrapProgram $out/libexec/sushi-start \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = "http://en.wikipedia.org/wiki/Sushi_(software)";
    description = "A quick previewer for Nautilus";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}

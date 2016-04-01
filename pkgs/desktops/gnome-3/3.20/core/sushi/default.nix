{ stdenv, fetchurl, pkgconfig, file, intltool, gobjectIntrospection, glib
, clutter_gtk, clutter-gst, gnome3, gtksourceview, libmusicbrainz
, webkitgtk, libmusicbrainz5, icu, makeWrapper, gst_all_1
, gdk_pixbuf, librsvg, gtk3, harfbuzz }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  propagatedUserEnvPkgs = [ gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good ];

  buildInputs = [ pkgconfig file intltool gobjectIntrospection glib gtk3
                  clutter_gtk clutter-gst gnome3.gjs gtksourceview gdk_pixbuf
                  librsvg gnome3.defaultIconTheme libmusicbrainz5 webkitgtk
                  gnome3.evince icu makeWrapper harfbuzz ];

  enableParallelBuilding = true;

  broken = true; # seems to include ht-ft.h instead of harfbuzz/ht-ft.h

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
    maintainers = gnome3.maintainers;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}

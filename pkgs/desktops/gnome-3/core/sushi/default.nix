{ stdenv, fetchurl, pkgconfig, file, intltool, gobjectIntrospection, glib
, clutter-gtk, clutter-gst, gnome3, gtksourceview
, webkitgtk, libmusicbrainz5, icu, makeWrapper, gst_all_1
, gdk_pixbuf, librsvg, gtk3, harfbuzz }:

stdenv.mkDerivation rec {
  name = "sushi-${version}";
  version = "3.28.3";

  src = fetchurl {
    url = "mirror://gnome/sources/sushi/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1yydd34q7r05z0jdgym3r4f8jv8snrcvvhxw0vxn6damlvj5lbiw";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "sushi"; attrPath = "gnome3.sushi"; };
  };

  propagatedUserEnvPkgs = [ gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ file intltool gobjectIntrospection glib gtk3
                  clutter-gtk clutter-gst gnome3.gjs gtksourceview gdk_pixbuf
                  librsvg gnome3.defaultIconTheme libmusicbrainz5 webkitgtk
                  gnome3.evince icu makeWrapper harfbuzz ];

  enableParallelBuilding = true;

  postConfigure = ''
    substituteInPlace src/libsushi/sushi-font-widget.h \
        --replace "<hb-ft.h>" "<harfbuzz/hb-ft.h>"
    substituteInPlace src/libsushi/sushi-font-widget.c \
        --replace "<hb-glib.h>" "<harfbuzz/hb-glib.h>"
  '';

  preFixup = ''
    wrapProgram $out/libexec/sushi-start \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = "https://en.wikipedia.org/wiki/Sushi_(software)";
    description = "A quick previewer for Nautilus";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}

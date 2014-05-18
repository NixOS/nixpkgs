{ stdenv, intltool, fetchurl, gst_all_1
, clutter_gtk, clutter-gst, pygobject3, shared_mime_info
, pkgconfig, gtk3, glib, hicolor_icon_theme
, bash, makeWrapper, itstool, libxml2, dbus_glib
, gnome3, librsvg, gdk_pixbuf, file }:

stdenv.mkDerivation rec {
  name = "totem-3.12.1";

  src = fetchurl {
    url = "mirror://gnome/sources/totem/3.12/${name}.tar.xz";
    sha256 = "dd168cdd4051d01131d47c24fa45bfd08b6ccf45900ac4b64bae47f6f47a35e3";
  };

  doCheck = true;

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ pkgconfig gtk3 glib intltool itstool libxml2 gnome3.grilo
                  clutter_gtk clutter-gst gnome3.totem-pl-parser gnome3.grilo-plugins
                  gst_all_1.gstreamer gst_all_1.gst-plugins-base
                  gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad
                  gnome3.libpeas pygobject3 shared_mime_info dbus_glib
                  gdk_pixbuf gnome3.gnome_icon_theme librsvg
                  hicolor_icon_theme gnome3.gnome_icon_theme_symbolic
                  gnome3.gsettings_desktop_schemas makeWrapper file ];

  preFixup = ''
    wrapProgram "$out/bin/totem" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0" \
      --prefix GRL_PLUGIN_PATH : "${gnome3.grilo-plugins}/lib/grilo-0.2" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"

    rm $out/share/icons/hicolor/icon-theme.cache
  '';

  patches = [ ./fix_files_loss.patch ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Videos;
    description = "Movie player for the GNOME desktop based on GStreamer";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

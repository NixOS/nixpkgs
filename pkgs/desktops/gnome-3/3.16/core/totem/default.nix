{ stdenv, intltool, fetchurl, gst_all_1
, clutter_gtk, clutter-gst, pygobject3, shared_mime_info
, pkgconfig, gtk3, glib, hicolor_icon_theme
, bash, makeWrapper, itstool, libxml2, dbus_glib
, gnome3, librsvg, gdk_pixbuf, file }:

stdenv.mkDerivation rec {
  name = "totem-${gnome3.version}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/totem/${gnome3.version}/${name}.tar.xz";
    sha256 = "1qv6s7c06r6kdrd3jjqk8h79y8a7h8pjcx02rzp869jr7d9hkcb9";
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
                  gdk_pixbuf gnome3.adwaita-icon-theme librsvg gnome3.gnome_desktop
                  hicolor_icon_theme gnome3.adwaita-icon-theme
                  gnome3.gsettings_desktop_schemas makeWrapper file ];

  preFixup = ''
    wrapProgram "$out/bin/totem" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0" \
      --prefix GRL_PLUGIN_PATH : "${gnome3.grilo-plugins}/lib/grilo-0.2" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"

  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Videos;
    description = "Movie player for the GNOME desktop based on GStreamer";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

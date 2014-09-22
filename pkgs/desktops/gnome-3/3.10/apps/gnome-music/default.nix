{ stdenv, intltool, fetchurl, gdk_pixbuf, tracker
, python3, libxml2, python3Packages, libnotify
, pkgconfig, gtk3, glib, hicolor_icon_theme, cairo
, makeWrapper, itstool, gnome3, librsvg, gst_all_1 }:

stdenv.mkDerivation rec {
  name = "gnome-music-3.10.4";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-music/3.10/${name}.tar.xz";
    sha256 = "64220d4c0f9115a6ed27ec99c7ec7afc065d12e5a32371936f303ef981f5325f";
  };

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ pkgconfig gtk3 glib intltool itstool gnome3.libmediaart
                  gdk_pixbuf gnome3.gnome_icon_theme librsvg python3
                  gnome3.grilo libxml2 python3Packages.pygobject3 libnotify
                  python3Packages.pycairo python3Packages.dbus
                  gst_all_1.gstreamer gst_all_1.gst-plugins-base
                  gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad
                  hicolor_icon_theme gnome3.gnome_icon_theme_symbolic
                  gnome3.gsettings_desktop_schemas makeWrapper tracker ];

  enableParallelBuilding = true;

  preFixup = ''
    wrapProgram "$out/bin/gnome-music" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0" \
      --prefix GRL_PLUGIN_PATH : "${gnome3.grilo-plugins}/lib/grilo-0.2" \
      --prefix PYTHONPATH : "$PYTHONPATH"

    rm $out/share/icons/hicolor/icon-theme.cache
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Music;
    description = "Music player and management application for the GNOME desktop environment";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

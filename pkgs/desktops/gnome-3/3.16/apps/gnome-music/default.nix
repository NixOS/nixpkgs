{ stdenv, intltool, fetchurl, gdk_pixbuf, tracker
, python3, libxml2, python3Packages, libnotify, wrapGAppsHook
, pkgconfig, gtk3, glib, hicolor_icon_theme, cairo
, makeWrapper, itstool, gnome3, librsvg, gst_all_1 }:

stdenv.mkDerivation rec {
  name = "gnome-music-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-music/${gnome3.version}/${name}.tar.xz";
    sha256 = "1pyj192kva0swad6w2kaj5shcwpgiflyda6zmsiaximsgzc4as8i";
  };

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ pkgconfig gtk3 glib intltool itstool gnome3.libmediaart
                  gdk_pixbuf gnome3.adwaita-icon-theme librsvg python3
                  gnome3.grilo gnome3.grilo-plugins libxml2 python3Packages.pygobject3 libnotify
                  python3Packages.pycairo python3Packages.dbus gnome3.totem-pl-parser
                  gst_all_1.gstreamer gst_all_1.gst-plugins-base
                  gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad
                  hicolor_icon_theme gnome3.adwaita-icon-theme wrapGAppsHook
                  gnome3.gsettings_desktop_schemas makeWrapper tracker ];

  wrapPrefixVariables = [ "PYTHONPATH" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Music;
    description = "Music player and management application for the GNOME desktop environment";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

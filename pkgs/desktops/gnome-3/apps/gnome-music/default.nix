{ stdenv, intltool, fetchurl, gdk_pixbuf, tracker, tracker-miners
, libxml2, python3Packages, libnotify, wrapGAppsHook
, pkgconfig, gtk3, glib, cairo
, makeWrapper, itstool, gnome3, librsvg, gst_all_1 }:

stdenv.mkDerivation rec {
  name = "gnome-music-${version}";
  version = "3.26.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-music/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0mam7d0lzl7ljd9lym9gkvqwvddic122sdmcgpjir58pmmg9bx8b";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-music"; attrPath = "gnome3.gnome-music"; };
  };

  propagatedUserEnvPkgs = [ gnome3.gnome-themes-standard ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk3 glib intltool itstool gnome3.libmediaart
                  gdk_pixbuf gnome3.defaultIconTheme librsvg python3Packages.python
                  gnome3.grilo gnome3.grilo-plugins gnome3.totem-pl-parser libxml2 libnotify
                  python3Packages.pycairo python3Packages.dbus-python python3Packages.requests
                  python3Packages.pygobject3 gst_all_1.gstreamer gst_all_1.gst-plugins-base
                  gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad wrapGAppsHook
                  gnome3.gsettings-desktop-schemas makeWrapper tracker tracker-miners ];

  wrapPrefixVariables = [ "PYTHONPATH" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Music;
    description = "Music player and management application for the GNOME desktop environment";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

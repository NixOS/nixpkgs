{ stdenv, fetchurl, pkgconfig, intltool, itstool, libxml2, dbus_glib,
  libxklavier, libcanberra_gtk3, librsvg, libappindicator-gtk3,
  desktop_file_utils, gnome3, mate, hicolor_icon_theme, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  name = "mate-control-center-${version}";
  version = "1.20.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "0qq3ln40w7lxa7qvbvbsgdq1c5ybzqw3bw2x4z6y6brl4c77sbh7";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    itstool
    desktop_file_utils
    wrapGAppsHook
  ];

  buildInputs = [
    libxml2
    dbus_glib
    libxklavier
    libcanberra_gtk3
    librsvg
    libappindicator-gtk3
    gnome3.gtk
    gnome3.dconf
    hicolor_icon_theme
    mate.mate-desktop
    mate.libmatekbd
    mate.mate-menus
    mate.marco
    mate.mate-settings-daemon
  ];

  configureFlags = "--disable-update-mimedb";

  meta = with stdenv.lib; {
    description = "Utilities to configure the MATE desktop";
    homepage = https://github.com/mate-desktop/mate-control-center;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}

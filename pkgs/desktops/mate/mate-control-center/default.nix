{ stdenv, fetchurl, pkgconfig, intltool, itstool, libxml2, dbus-glib,
  libxklavier, libcanberra-gtk3, librsvg, libappindicator-gtk3,
  desktop-file-utils, gnome3, mate, hicolor-icon-theme, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  name = "mate-control-center-${version}";
  version = "1.20.2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "1x40gxrz1hrzbdfl8vbag231g08h45vaky5z827k44qwl6pjd6nl";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    itstool
    desktop-file-utils
    wrapGAppsHook
  ];

  buildInputs = [
    libxml2
    dbus-glib
    libxklavier
    libcanberra-gtk3
    librsvg
    libappindicator-gtk3
    gnome3.gtk
    gnome3.dconf
    hicolor-icon-theme
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

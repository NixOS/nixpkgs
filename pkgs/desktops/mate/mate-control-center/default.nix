{ stdenv, fetchurl, pkgconfig, intltool, itstool, libxml2, dbus_glib, libxklavier, libcanberra_gtk3, desktop_file_utils, gnome3, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-control-center-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "0flnn0h8f5aqyccwrlv7qxchvr3kqmlfdga6wq28d55zkpv5m7dl";
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
    gnome3.gtk
    gnome3.dconf
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

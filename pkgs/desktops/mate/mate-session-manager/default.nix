{ stdenv, fetchurl, pkgconfig, intltool, itstool, dbus_glib, systemd, xtrans, xorg, gnome3, mate, hicolor_icon_theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-session-manager-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "11ii7azl8rn9mfymcmcbpysyd12vrxp4s8l3l6yk4mwlr3gvzxj0";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    wrapGAppsHook
  ];

  buildInputs = [
    dbus_glib
    systemd
    xtrans
    hicolor_icon_theme
    xorg.libSM
    gnome3.gtk3
    gnome3.gsettings_desktop_schemas
    mate.mate-desktop
  ];

  meta = with stdenv.lib; {
    description = "MATE Desktop session manager";
    homepage = https://github.com/mate-desktop/mate-session-manager;
    license = with licenses; [ gpl2 lgpl2 ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}

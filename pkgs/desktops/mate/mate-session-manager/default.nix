{ stdenv, fetchurl, pkgconfig, intltool, xtrans, dbus_glib, systemd,
  libSM, libXtst, gtk3, hicolor_icon_theme, mate,
  wrapGAppsHook
}:

stdenv.mkDerivation rec {
  name = "mate-session-manager-${version}";
  version = "1.18.2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "11ii7azl8rn9mfymcmcbpysyd12vrxp4s8l3l6yk4mwlr3gvzxj0";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    xtrans
    wrapGAppsHook
  ];

  buildInputs = [
    dbus_glib
    systemd
    libSM
    libXtst
    gtk3
    mate.mate-desktop
    hicolor_icon_theme
  ];

  meta = with stdenv.lib; {
    description = "MATE Desktop session manager";
    homepage = https://github.com/mate-desktop/mate-session-manager;
    license = with licenses; [ gpl2 lgpl2 ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}

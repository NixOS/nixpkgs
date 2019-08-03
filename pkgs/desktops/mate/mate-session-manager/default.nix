{ stdenv, fetchurl, pkgconfig, intltool, xtrans, dbus-glib, systemd,
  libSM, libXtst, gtk3, hicolor-icon-theme, mate,
  wrapGAppsHook
}:

stdenv.mkDerivation rec {
  name = "mate-session-manager-${version}";
  version = "1.22.1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1ix8picxgc28m5zd0ww3zvzw6rz38wvzsrbqw28hghrfg926h6ig";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    xtrans
    wrapGAppsHook
  ];

  buildInputs = [
    dbus-glib
    systemd
    libSM
    libXtst
    gtk3
    mate.mate-desktop
    hicolor-icon-theme
  ];

  meta = with stdenv.lib; {
    description = "MATE Desktop session manager";
    homepage = https://github.com/mate-desktop/mate-session-manager;
    license = with licenses; [ gpl2 lgpl2 ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}

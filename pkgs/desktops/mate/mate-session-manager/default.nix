{ stdenv, fetchurl, pkgconfig, intltool, xtrans, dbus-glib, systemd,
  libSM, libXtst, gtk3, hicolor-icon-theme, mate,
  wrapGAppsHook
}:

stdenv.mkDerivation rec {
  name = "mate-session-manager-${version}";
  version = "1.20.2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "05qq07b568qf6zyy459wajhfpbx1wfrinw3hsbky7abdjfn529dy";
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

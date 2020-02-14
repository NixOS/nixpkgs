{ stdenv, fetchurl, pkgconfig, gettext, xtrans, dbus-glib, systemd,
  libSM, libXtst, gtk3, epoxy, polkit, hicolor-icon-theme, mate,
  wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "mate-session-manager";
  version = "1.24.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "01scj5d1xlri9b2id8gm9kfni9nzhdjdf7rag7fvcxwqp7baz3h3";
  };

  nativeBuildInputs = [
    pkgconfig
    gettext
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
    epoxy
    polkit
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "MATE Desktop session manager";
    homepage = "https://github.com/mate-desktop/mate-session-manager";
    license = with licenses; [ gpl2 lgpl2 ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}

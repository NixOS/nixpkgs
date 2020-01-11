{ stdenv, fetchurl, pkgconfig, intltool, glib, libcanberra-gtk3,
  libnotify, libwnck3, gtk3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-notification-daemon";
  version = "1.22.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0f8m3m94iqj2x61dzwwvwq2qlsl2ma8pqr6rfns5pzd0nj0waz0m";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    wrapGAppsHook
  ];

  buildInputs = [
    libcanberra-gtk3
    libnotify
    libwnck3
    gtk3
  ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  meta = with stdenv.lib; {
    description = "Notification daemon for MATE";
    homepage = https://github.com/mate-desktop/mate-notification-daemon;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}

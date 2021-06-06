{ lib, stdenv, fetchurl, pkg-config, gettext, glib, libcanberra-gtk3,
  libnotify, libwnck3, gtk3, libxml2, wrapGAppsHook, mateUpdateScript }:

stdenv.mkDerivation rec {
  pname = "mate-notification-daemon";
  version = "1.24.2";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "02mf9186cbziyvz7ycb0j9b7rn085a7f9hrm03n28q5kz0z1k92q";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    libxml2 # for xmllint
    wrapGAppsHook
  ];

  buildInputs = [
    libcanberra-gtk3
    libnotify
    libwnck3
    gtk3
  ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "Notification daemon for MATE Desktop";
    homepage = "https://github.com/mate-desktop/mate-notification-daemon";
    license = with licenses; [ gpl2Plus gpl3Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}

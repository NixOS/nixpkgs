{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, glib
, libcanberra-gtk3
, libnotify
, libwnck
, gtk-layer-shell
, gtk3
, libxml2
, mate-desktop
, mate-panel
, wrapGAppsHook3
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-notification-daemon";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "pDEDSOrYZsvLm0xGP00mXMapahp4KpQRoIsjvWXbsuA=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    libxml2 # for xmllint
    wrapGAppsHook3
  ];

  buildInputs = [
    libcanberra-gtk3
    libnotify
    libwnck
    gtk-layer-shell
    gtk3
    mate-desktop
    mate-panel
  ];

  configureFlags = [ "--enable-in-process" ];

  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Notification daemon for MATE Desktop";
    mainProgram = "mate-notification-properties";
    homepage = "https://github.com/mate-desktop/mate-notification-daemon";
    license = with licenses; [ gpl2Plus gpl3Plus ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}

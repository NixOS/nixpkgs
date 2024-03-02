{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, glib
, libcanberra-gtk3
, libnotify
, libwnck
, gtk3
, libxml2
, mate-desktop
, mate-panel
, wrapGAppsHook
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-notification-daemon";
  version = "1.26.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "Dq6SlsSKPHH9VvGTGWH5LSnkWgRf5fGgX4PHQAwxmSQ=";
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
    libwnck
    gtk3
    mate-desktop
    mate-panel
  ];

  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Notification daemon for MATE Desktop";
    homepage = "https://github.com/mate-desktop/mate-notification-daemon";
    license = with licenses; [ gpl2Plus gpl3Plus ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}

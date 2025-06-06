{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, gtk3
, dbus-glib
, libXScrnSaver
, libnotify
, libxml2
, mate-desktop
, mate-menus
, mate-panel
, pam
, systemd
, wrapGAppsHook3
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-screensaver";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "ag8kqPhKL5XhARSrU+Y/1KymiKVf3FA+1lDgpBDj6nA=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    libxml2 # provides xmllint
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    dbus-glib
    libXScrnSaver
    libnotify
    mate-desktop
    mate-menus
    mate-panel
    pam
    systemd
  ];

  configureFlags = [ "--without-console-kit" ];

  makeFlags = [ "DBUS_SESSION_SERVICE_DIR=$(out)/etc" ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Screen saver and locker for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}

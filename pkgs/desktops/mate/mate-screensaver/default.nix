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
, pam
, systemd
, mate
, wrapGAppsHook
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-screensaver";
  version = "1.26.2";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "2pcAziQUW9VdJJJ+7P5tMdClLq6G5WOyxlBUs1al/34=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    libxml2 # provides xmllint
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    dbus-glib
    libXScrnSaver
    libnotify
    pam
    systemd
    mate.mate-desktop
    mate.mate-menus
    mate.mate-panel
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

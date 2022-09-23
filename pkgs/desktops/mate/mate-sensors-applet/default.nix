{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, itstool
, gtk3
, libxml2
, libxslt
, libatasmart
, libnotify
, lm_sensors
, mate
, hicolor-icon-theme
, wrapGAppsHook
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-sensors-applet";
  version = "1.26.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0s19r30fsicqvvcnz57lv158pi35w9zn5i7h5hz59224y0zpqhsc";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
    wrapGAppsHook
  ];

  # maybe add nvidia-settings later on
  buildInputs = [
    gtk3
    libxml2
    libxslt
    libatasmart
    libnotify
    lm_sensors
    mate.mate-panel
    hicolor-icon-theme
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    homepage = "https://github.com/mate-desktop/mate-sensors-applet";
    description = "MATE panel applet for hardware sensors";
    license = with licenses; [ gpl2Plus ];
    platforms = platforms.linux;
    maintainers = teams.mate.members;
  };
}

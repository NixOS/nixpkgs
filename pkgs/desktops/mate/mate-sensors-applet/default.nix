{ lib, stdenv, fetchurl, pkg-config, gettext, itstool, gtk3, libxml2, libxslt, libatasmart, libnotify
, lm_sensors, mate, hicolor-icon-theme, wrapGAppsHook, mateUpdateScript }:

stdenv.mkDerivation rec {
  pname = "mate-sensors-applet";
  version = "1.24.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1nb4fy3mcymv7pmnc0czpxgp1sqvs533jwnqv1b5cqby415ljb16";
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
    maintainers = [ maintainers.romildo ];
  };
}

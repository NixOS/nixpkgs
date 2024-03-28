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
, mate-panel
, hicolor-icon-theme
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-sensors-applet";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1GU2ZoKvj+uGGCg8l4notw22/RfKj6lQrG9xAQIxWoE=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
  ];

  buildInputs = [
    gtk3
    libxml2
    libxslt
    libatasmart
    libnotify
    lm_sensors
    mate-panel
    hicolor-icon-theme
  ];

  configureFlags = [ "--enable-in-process" ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    homepage = "https://github.com/mate-desktop/mate-sensors-applet";
    description = "MATE panel applet for hardware sensors";
    license = with licenses; [ gpl2Plus ];
    platforms = platforms.linux;
    maintainers = teams.mate.members;
  };
}

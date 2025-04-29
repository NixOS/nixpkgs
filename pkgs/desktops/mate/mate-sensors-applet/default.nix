{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  gettext,
  itstool,
  gtk3,
  libxml2,
  libxslt,
  libatasmart,
  libnotify,
  lm_sensors,
  mate-panel,
  hicolor-icon-theme,
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
  pname = "mate-sensors-applet";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1GU2ZoKvj+uGGCg8l4notw22/RfKj6lQrG9xAQIxWoE=";
  };

  patches = [
    # Fix an invalid pointer crash with glib 2.83.2
    # https://github.com/mate-desktop/mate-sensors-applet/pull/137
    (fetchpatch {
      url = "https://github.com/mate-desktop/mate-sensors-applet/commit/9b74dc16d852a40d37f7ce6c236406959fd013e5.patch";
      hash = "sha256-PjMc2uEFMljaiKOM5lf6MsdWztZkMfb2Vuxs9tgdaos=";
    })
  ];

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
    teams = [ teams.mate ];
  };
}

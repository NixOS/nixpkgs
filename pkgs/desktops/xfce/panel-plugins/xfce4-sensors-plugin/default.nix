{
  stdenv,
  lib,
  fetchurl,
  gettext,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  glib,
  gtk3,
  libX11,
  libXext,
  libxfce4ui,
  libxfce4util,
  xfce4-panel,
  libnotify,
  lm_sensors,
  libXNVCtrl,
  nvidiaSupport ? lib.meta.availableOn stdenv.hostPlatform libXNVCtrl,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-sensors-plugin";
  version = "1.5.0";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/xfce4-sensors-plugin/${lib.versions.majorMinor finalAttrs.version}/xfce4-sensors-plugin-${finalAttrs.version}.tar.xz";
    hash = "sha256-hARCuH/d3NhZW9n4Pqi4H3cf4pa7nSq/Dhl54ghyeuk=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    libX11
    libXext
    libxfce4ui
    libxfce4util
    xfce4-panel
    libnotify
    lm_sensors
  ]
  ++ lib.optionals nvidiaSupport [ libXNVCtrl ];

  mesonFlags = [
    (lib.mesonEnable "xnvctrl" nvidiaSupport)
  ];

  passthru.updateScript = gitUpdater {
    url = "https://gitlab.xfce.org/panel-plugins/xfce4-sensors-plugin";
    rev-prefix = "xfce4-sensors-plugin-";
  };

  meta = {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-sensors-plugin";
    description = "Panel plug-in for different sensors using acpi, lm_sensors and hddtemp";
    mainProgram = "xfce4-sensors";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.xfce ];
  };
})

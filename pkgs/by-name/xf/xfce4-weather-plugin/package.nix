{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  gettext,
  meson,
  ninja,
  pkg-config,
  glib,
  gtk3,
  json_c,
  libxml2,
  libsoup_3,
  upower,
  libxfce4ui,
  libxfce4util,
  xfce4-panel,
  xfconf,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-weather-plugin";
  version = "0.12.0";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/xfce4-weather-plugin/${lib.versions.majorMinor finalAttrs.version}/xfce4-weather-plugin-${finalAttrs.version}.tar.xz";
    hash = "sha256-XdkLAywG70tkuBgCMVTvlGOixpSgKQ5X80EilsdUX/Y=";
  };

  patches = [
    # meson-build: Add missing HAVE_UPOWER_GLIB definition
    # https://gitlab.xfce.org/panel-plugins/xfce4-weather-plugin/-/merge_requests/37
    (fetchpatch {
      url = "https://gitlab.xfce.org/panel-plugins/xfce4-weather-plugin/-/commit/1d8e5e5dbbc4d53e4b810f9b01a460197cd47b64.patch";
      hash = "sha256-g9AIp1iBcA3AxD1tpnv32PvxxulXYjFvQh3EqD1gmHg=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    glib # glib-compile-resources
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    glib
    gtk3
    json_c
    libxml2
    libsoup_3
    upower
    libxfce4ui
    libxfce4util
    xfce4-panel
    xfconf
  ];

  passthru.updateScript = gitUpdater {
    url = "https://gitlab.xfce.org/panel-plugins/xfce4-weather-plugin";
    rev-prefix = "xfce4-weather-plugin-";
  };

  meta = {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-weather-plugin";
    description = "Weather plugin for the Xfce desktop environment";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.xfce ];
  };
})

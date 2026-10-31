{
  lib,
  stdenv,
  fetchFromGitHub,
  gettext,
  pkg-config,
  intltool,
  gtk3,
  libxfce4ui,
  libxfce4util,
  xfce4-dev-tools,
  xfce4-panel,
  i3ipc-glib,
}:

stdenv.mkDerivation {
  pname = "xfce4-i3-workspaces-plugin";
  version = "1.4.2-unstable-2025-05-28";

  src = fetchFromGitHub {
    owner = "denesb";
    repo = "xfce4-i3-workspaces-plugin";
    # Fix build with GCC 15.
    rev = "d7c2d978e736a5e07f96142a31fac3bb7d0806b4";
    hash = "sha256-9xr9uoXjriVmFmotsaM/wVAaJA/k5Dl/SWsPo4skV2E=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
    intltool
    xfce4-dev-tools
  ];

  buildInputs = [
    gtk3
    libxfce4ui
    libxfce4util
    xfce4-panel
    i3ipc-glib
  ];

  patches = [
    # Fix build with gettext 0.25
    # https://hydra.nixos.org/build/302762031/nixlog/2
    # FIXME: remove when gettext is fixed
    ./gettext-0.25.patch
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/denesb/xfce4-i3-workspaces-plugin";
    description = "Workspace switcher plugin for xfce4-panel which can be used for the i3 window manager";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ berbiche ];
    teams = [ lib.teams.xfce ];
  };
}

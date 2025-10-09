{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  glib,
  meson,
  ninja,
  pkg-config,
  vala,
  wayland-scanner,
  accountsservice,
  elementary-settings-daemon,
  granite,
  gtk3,
  libgee,
  libhandy,
  libportal,
  packagekit,
  wayland,
  wingpanel,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wingpanel-quick-settings";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "quick-settings";
    rev = finalAttrs.version;
    hash = "sha256-82XlZDnXuUB0PPmInrSQh1vrwnOYt9RplKWwYxIirVo=";
  };

  nativeBuildInputs = [
    glib # glib-compile-resources
    meson
    ninja
    pkg-config
    vala
    wayland-scanner
  ];

  buildInputs = [
    accountsservice
    elementary-settings-daemon # for prefers-color-scheme
    glib
    granite
    gtk3
    libgee
    libhandy
    libportal
    packagekit
    wayland
    wingpanel
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Quick settings menu for Wingpanel";
    homepage = "https://github.com/elementary/quick-settings";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
})

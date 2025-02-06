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
  elementary-settings-daemon,
  granite,
  gtk3,
  libgee,
  libhandy,
  libportal,
  packagekit,
  wayland,
  wayland-scanner,
  wingpanel,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wingpanel-quick-settings";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "quick-settings";
    rev = finalAttrs.version;
    hash = "sha256-I5RCMd3lkWOkpoawCXYuGHDa49A+wVlIlM8U2hRfq/o=";
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
    maintainers = lib.teams.pantheon.members;
  };
})

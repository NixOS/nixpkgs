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
  wingpanel,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wingpanel-quick-settings";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "quick-settings";
    rev = finalAttrs.version;
    hash = "sha256-k8K6zGTLYGSsi5NtohbaGg4oVVovktR7BInN8BUE5bQ=";
  };

  nativeBuildInputs = [
    glib # glib-compile-resources
    meson
    ninja
    pkg-config
    vala
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

{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "quick-settings";
    rev = finalAttrs.version;
    hash = "sha256-77NkzdE0Z655qeh718L4Mil6FkMxTNaEqh7DLHoldQ4=";
  };

  patches = [
    # Adapt to uid_t being an available type since Vala 0.56.17
    # https://github.com/elementary/quick-settings/pull/91
    (fetchpatch {
      url = "https://github.com/elementary/quick-settings/commit/765a77ded353e4eedfe62a2116e252cc107cef5a.patch";
      hash = "sha256-Q9+eLwjsHktEdVRh7LmmJKK5RcizI+lIiIgICZcILQY=";
    })
  ];

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
    maintainers = lib.teams.pantheon.members;
  };
})

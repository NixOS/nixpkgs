{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook3,
  granite,
  gtk3,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "elementary-bluetooth-daemon";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "bluetooth-daemon";
    rev = finalAttrs.version;
    hash = "sha256-09udSmd51l7zPe83RBg+AihpwsELclEF+Jn+5DKdJUI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    granite
    gtk3
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Send and receive files via bluetooth";
    homepage = "https://github.com/elementary/bluetooth-daemon";
    license = lib.licenses.gpl3Plus;
    maintainers = lib.teams.pantheon.members;
    platforms = lib.platforms.linux;
    mainProgram = "io.elementary.bluetooth";
  };
})

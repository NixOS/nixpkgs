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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "bluetooth-daemon";
    rev = finalAttrs.version;
    hash = "sha256-Qr4hg2OY7l/LpGB+/yfIXCnjCXsjQLFZX9f4CoYRtLo=";
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
    teams = [ lib.teams.pantheon ];
    platforms = lib.platforms.linux;
    mainProgram = "io.elementary.bluetooth";
  };
})

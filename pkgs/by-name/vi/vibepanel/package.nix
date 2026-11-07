{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  gtk4,
  gtk4-layer-shell,
  libpulseaudio,
  udev,
  dbus,
  wayland,
  ...
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vibepanel";
  version = "0.14.1";
  rev = "v${finalAttrs.version}";
  __structuredAttrs = true;
  srcHash = "sha256-QsYSfNzaAtUTJGuGxikproRgMmmcKO4ZCkyrbruh4Z4=";
  cargoHash = "sha256-PPwMNvhJCvjoMwCBu0aeONXBNlCecgYUnwm9PnjHI0c=";

  src = fetchFromGitHub {
    owner = "prankstr";
    repo = finalAttrs.pname;
    hash = finalAttrs.srcHash;
    inherit (finalAttrs) rev;
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    gtk4-layer-shell
    libpulseaudio
    udev
    dbus
    wayland
  ];

  meta = {
    description = "A GTK4 panel for Wayland with integrated notifications, OSD, and quick settings";
    homepage = "https://github.com/prankstr/vibepanel";
    license = lib.licenses.mit;
    mainProgram = "vibepanel";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      zaphyra
    ];
  };
})

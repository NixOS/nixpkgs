{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  rustPlatform,
  atk,
  gtk-layer-shell,
  gtk3,
  glib,
  glib-networking,
  nix-update-script,
  webkitgtk_4_1,
  wrapGAppsHook3,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wewa";
  version = "0.3.5";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ownself";
    repo = "wewa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cVd3v02sT/RnpM2u5thS2esb/GLJ2++07tTK7UjPXnU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    atk
    gtk3
    glib
    glib-networking
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    gtk-layer-shell
    webkitgtk_4_1
  ];

  cargoHash = "sha256-Jvl9+LiFvMI1k7jCJh2WPz7FaPo0KSxSVLaCXbFAXKs=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform cli dynamic wallpaper tool to make website or shader as your wallpaper";
    homepage = "https://github.com/ownself/wewa";
    changelog = "https://github.com/ownself/wewa/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ choco98 ];
    mainProgram = "wewa";
  };
})

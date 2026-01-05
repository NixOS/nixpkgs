{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  wrapGAppsHook4,
  glib,
  nix-update-script,
  stdenv,
  meson,
  ninja,
  cargo,
  rustc,
  sqlite,
  openssl,
  desktop-file-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "waytrogen";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "nikolaizombie1";
    repo = "waytrogen";
    tag = finalAttrs.version;
    hash = "sha256-zFRSWAVyTWvH6nxiacQbrrLRlu0Xac53XFaA6FcSf6M=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-/QCDxno0xZ9hLq0U6FNAZX7x+Kx5xaMtT/mR/GrNavs=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    meson
    ninja
    rustPlatform.cargoSetupHook
    cargo
    rustc
    desktop-file-utils
  ];

  buildInputs = [
    glib
    sqlite
    openssl
  ];

  preBuild = ''export OUT_PATH=$out'';

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  mesonFlags = [ "-Dcargo_features=nixos" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightning fast wallpaper setter for Wayland";
    longDescription = ''
      A GUI wallpaper setter for Wayland that is a spiritual successor
      for the minimalistic wallpaper changer for X11 nitrogen. Written purely
      in the Rust 🦀 programming language. Supports hyprpaper, swaybg, mpvpaper and swww wallpaper changers.
    '';
    homepage = "https://github.com/nikolaizombie1/waytrogen";
    changelog = "https://github.com/nikolaizombie1/waytrogen/releases/tag/${finalAttrs.version}";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [
      genga898
      nikolaizombie1
    ];
    mainProgram = "waytrogen";
    platforms = lib.platforms.linux;
  };
})

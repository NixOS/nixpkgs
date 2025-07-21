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

stdenv.mkDerivation rec {
  pname = "waytrogen";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "nikolaizombie1";
    repo = "waytrogen";
    tag = version;
    hash = "sha256-vFzOGadWR5xwhIKrKPHoAHstoeyFw4GrS5aYlpvEF5E=";
  };

  useFetchCargoVendor = true;
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-k6n6aWEJ/8Dkbd68CJfJ7kbRTltCuQ4AtZ5dALFD3lU=";
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
    changelog = "https://github.com/nikolaizombie1/waytrogen/releases/tag/${version}";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [
      genga898
      nikolaizombie1
    ];
    mainProgram = "waytrogen";
    platforms = lib.platforms.linux;
  };
}

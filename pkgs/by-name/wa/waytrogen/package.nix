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
}:

stdenv.mkDerivation rec {
  pname = "waytrogen";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "nikolaizombie1";
    repo = "waytrogen";
    tag = version;
    hash = "sha256-Y83l6GKuaH+976MTOo03saVBh6gDegxyo3WRsRA+iQI=";
  };

  useFetchCargoVendor = true;
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-t3bDgY1Jtc/lE3WOnmti12shwsmSX3HhGBtYjesQ7hk=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    meson
    ninja
    rustPlatform.cargoSetupHook
    cargo
    rustc
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

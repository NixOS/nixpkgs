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
  bash,
  dbus,
  gtk4,
  ffmpeg,
  gsettings-desktop-schemas,
  libx11,
  libxcursor,
  libxrandr,
  libxi,
  libxcb,
  libxkbcommon,
  vulkan-loader,
  wayland,
  xdg-utils,
  makeWrapper,
  xdg-desktop-portal,
  libGL,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "waytrogen";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "nikolaizombie1";
    repo = "waytrogen";
    tag = finalAttrs.version;
    hash = "sha256-q+44xYmxXWkYfoMQtARCIIjvxwCxNTl1mH+wxcATnAk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-4FGY/MS8sB3dh8iCrA5yOl0/qiP9rzXf7v43iZe6FxU=";
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
    glib
    bash
    dbus
    makeWrapper
    sqlite
    gtk4
    dbus
    xdg-utils
    xdg-desktop-portal
  ];

  buildInputs = [
    glib
    sqlite
    openssl
    glib
    gtk4
    ffmpeg
    sqlite
    openssl
    gsettings-desktop-schemas
    libx11
    libxcursor
    libxrandr
    libxi
    libxcb
    libxkbcommon
    vulkan-loader
    wayland
    dbus
    xdg-utils
    xdg-desktop-portal
  ];

  preBuild = "export OUT_PATH=$out";

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  passthru.updateScript = nix-update-script { };

  preFixup = ''
    gappsWrapperArgs+=(
      --suffix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          wayland
          libxkbcommon
          vulkan-loader
          libGL
          dbus
        ]
      }
    )
  '';

  meta = {
    description = "Lightning fast wallpaper setter for Wayland";
    longDescription = ''
      A GUI wallpaper setter for Wayland that is a spiritual successor
      for the minimalistic wallpaper changer for X11 nitrogen. Written purely
      in the Rust 🦀 programming language. Supports hyprpaper, swaybg, mpvpaper, swww  and gSlapper wallpaper changers.
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

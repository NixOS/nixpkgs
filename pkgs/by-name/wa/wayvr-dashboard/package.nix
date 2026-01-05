# SPDX-FileCopyrightText: 2025 Hana Kretzer <hanakretzer@gmail.com>
#
# SPDX-License-Identifier: MIT
{
  alsa-lib,
  cargo-tauri,
  fetchFromGitHub,
  fetchNpmDeps,
  gdk-pixbuf,
  glib,
  lib,
  librsvg,
  nodejs,
  npmHooks,
  openssl,
  pkg-config,
  pulseaudio,
  rustPlatform,
  webkitgtk_4_1,
  wrapGAppsHook4,
}:
rustPlatform.buildRustPackage rec {
  pname = "wayvr-dashboard";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "olekolek1000";
    repo = "wayvr-dashboard";
    tag = version;
    hash = "sha256-C23O9EFOpGwamJuKjluBAMFF7YaNDqd61JVDkWyoy+E=";
  };

  cargoHash = "sha256-aljJ+N47rFSMAxdW4plqhHggLYHD+sJNUCcG/tWzUxU=";

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-kyb4xzBkNTCIzOEUTuPeESDOAqfWseoouUkZjqI/NhQ=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    alsa-lib
    gdk-pixbuf
    glib
    librsvg
    openssl
    webkitgtk_4_1
  ];

  preBuild = ''
    # using sass-embedded fails at executing node_modules/sass-embedded-linux-x64/dart-sass/src/dart
    rm -r node_modules/sass-embedded*
  '';

  postInstall = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ pulseaudio ]}}"
    )
    install -Dm644 wayvr-dashboard.svg $out/share/icons/hicolor/scalable/apps/wayvr-dashboard.svg
  '';

  cargoRoot = "src-tauri";
  buildAndTestSubdir = cargoRoot;

  meta = {
    description = "Work-in-progress overlay application for launching various applications and games directly into a VR desktop environment";
    homepage = "https://github.com/olekolek1000/wayvr-dashboard";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nanoyaki
      Scrumplex
    ];
    platforms = lib.platforms.linux;
    mainProgram = "wayvr-dashboard";
  };
}

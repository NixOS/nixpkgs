# SPDX-FileCopyrightText: 2025 Hana Kretzer <hanakretzer@gmail.com>
#
# SPDX-License-Identifier: MIT
{
  lib,
  rustPlatform,
  fetchNpmDeps,
  npmHooks,
  pkg-config,
  cargo-tauri,
  nodejs,
  glib,
  gtk3,
  gtk4,
  webkitgtk_4_1,
  libsoup_3,
  alsa-lib,

  fetchFromGitHub,
}:

let
  cargoRoot = "src-tauri";
in

rustPlatform.buildRustPackage rec {
  pname = "wayvr-dashboard";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "olekolek1000";
    repo = "wayvr-dashboard";
    tag = version;
    hash = "sha256-vs4lk0B/D51WsHWOgqpTcPHf8WFaRJCkJyHZImDsdqk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/Lik6Hy80h5BL4rquVa3J9Fzqg2cOZKsRsLFzTgMle4=";

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-W2X9g0LFIgkLbZBdr4OqodeN7U/h3nVfl3mKV9dsZTg=";
  };

  nativeBuildInputs = [
    pkg-config

    cargo-tauri.hook

    nodejs
    npmHooks.npmConfigHook
  ];

  buildInputs = [
    glib
    gtk3
    gtk4
    webkitgtk_4_1
    libsoup_3
    alsa-lib
  ];

  preBuild = ''
    # using sass-embedded fails at executing node_modules/sass-embedded-linux-x64/dart-sass/src/dart
    rm -r node_modules/sass-embedded*
  '';

  inherit cargoRoot;
  buildAndTestSubdir = cargoRoot;

  meta = {
    description = "A work-in-progress overlay application for launching various applications and games directly into a VR desktop environment";
    homepage = "https://github.com/olekolek1000/wayvr-dashboard";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nanoyaki
      Scrumplex
    ];
    platforms = lib.platforms.linux;
    mainProgram = "wayvr_dashboard";
  };
}

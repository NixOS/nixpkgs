{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,

  coreutils,
  cmake,
  ninja,
  pkg-config,
  wayland-scanner,

  dbus,
  freetype,
  glfw,
  onetbb,

  withGtkFileSelector ? false,
  gtk3,

  withWayland ? stdenv.hostPlatform.isLinux,
  libglvnd,
  libxkbcommon,
  wayland,
  wayland-protocols,
  libffi,

  md4c,
  pugixml,
  curl,
  zstd,
  nlohmann_json,
  nativefiledialog-extended,
  html-tidy,
  python3,
  pandoc,
}:

(import ./package-versions.nix {
  inherit
    lib
    stdenv
    fetchFromGitHub
    fetchpatch

    coreutils
    cmake
    ninja
    pkg-config
    wayland-scanner

    dbus
    freetype
    glfw
    onetbb

    withGtkFileSelector
    gtk3

    withWayland
    libglvnd
    libxkbcommon
    wayland
    wayland-protocols
    libffi

    md4c
    pugixml
    curl
    zstd
    nlohmann_json
    nativefiledialog-extended
    html-tidy
    python3
    pandoc
    ;
}).tracy_latest

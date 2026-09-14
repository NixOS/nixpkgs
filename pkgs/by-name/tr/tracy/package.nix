{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromGitLab,
  fetchurl,
  callPackage,

  coreutils,
  cmake,
  ninja,
  pkg-config,
  wayland-scanner,

  capstone,
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
}:

(import ./package-versions.nix {
  inherit
    lib
    stdenv
    fetchFromGitHub
    fetchFromGitLab
    fetchurl
    callPackage

    coreutils
    cmake
    ninja
    pkg-config
    wayland-scanner

    capstone
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
    ;
}).tracy_latest

{
  lib,
  fetchFromGitHub,
  rustPlatform,

  clang,
  llvmPackages,
  pkg-config,

  cacert,
  dbus,
  fftw,
  gdk-pixbuf,
  glib,
  gtk4,
  gtk4-layer-shell,
  libnotify,
  libxkbcommon,
  pipewire,
  pulseaudio,
  wayland,

  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wayle";
  version = "0-unstable-2026-02-12";
  src = fetchFromGitHub {
    owner = "Jas-SinghFSU";
    repo = "wayle";
    rev = "370f5caaa63704e02a2ba128e47cb8d06767804e";
    hash = "sha256-1aW6JgMEIyFN29iALrY02HcpV+gw0ICyg2XrJifX7Nc=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-yM39WIKDTmXWLF4RU5Y3NZNa1qlA0QsBodtFBb0bYZs=";

  cargoInstallFlags = [
    "--path"
    "wayle"
    "--path"
    "crates/wayle-shell"
  ];

  nativeBuildInputs = [
    clang
    llvmPackages.libclang
    pkg-config
  ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  buildInputs = [
    cacert
    dbus
    fftw
    gdk-pixbuf
    glib
    gtk4
    gtk4-layer-shell
    libnotify
    libxkbcommon
    pipewire
    pulseaudio
    wayland
  ];

  doCheck = false; # skip GUI tests that require fonts etc.

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Wayland Elements - A compositor agnostic shell with extensive customization ";
    homepage = "https://github.com/Jas-SinghFSU/wayle";
    maintainers = with lib.maintainers; [ lykos153 ];
    license = lib.licenses.mit;
  };
})

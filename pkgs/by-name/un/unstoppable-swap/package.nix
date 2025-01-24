{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  glib,
  gtk3,
  gobject-introspection,
  libsoup_2_4,
  webkitgtk_4_1,
}:

rustPlatform.buildRustPackage rec {
  pname = "unstoppable-swap";
  version = "1.0.0-rc.12";
  useFetchCargoVendor = true;
  nativeBuildInputs = [
    pkg-config
    gobject-introspection
  ];
  buildInputs = [
    glib
    gtk3
    libsoup_2_4
    webkitgtk_4_1
  ];

  src = fetchFromGitHub {
    owner = "UnstoppableSwap";
    repo = "core";
    rev = "${version}";
    hash = "sha256-KOtBw0LIPvQ4mnasq0lwpzaWGrA6QCTu/9MugwD969A=";
  };

  cargoHash = "sha256-3oJg6OoIVM9cUH+rH6vg9syqIFwAAfuWw9t44VApjOE=";

  meta = {
    description = "Bitcoin–Monero Cross-chain Atomic Swap (+ GUI)";
    homepage = "https://github.com/UnstoppableSwap/core";
    license = lib.licenses.gpl3;
    mainProgram = "swap";
    maintainers = with lib.maintainers; [ pixelsergey ];
  };
}

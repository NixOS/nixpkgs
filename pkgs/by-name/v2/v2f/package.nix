{
  autoPatchelfHook,
  fetchFromGitHub,
  lib,
  libGL,
  libgcc,
  libx11,
  libxcursor,
  libxi,
  libxkbcommon,
  lua5_4_compat,
  nix-update-script,
  pkg-config,
  rustPlatform,
  stdenvNoCC,
  wayland,
}:

let
  lua = lua5_4_compat;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "v2f";
  version = "0-unstable-2026-03-21";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ben-j-c";
    repo = "verilog2factorio";
    rev = "5a96763e2c170f5229c7f98615220fe682ef0894";
    hash = "sha256-4J7GfIW9KYgXwEc9wUmyHo8s0sOUJfIBIGcBkH/E0gI=";
  };

  cargoHash = "sha256-O5htpvkUnWdRTbIusTHxCTFLu45z/ZsQdHNtF4OazpQ=";

  nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [ autoPatchelfHook ] ++ [
    pkg-config
  ];

  buildInputs = [
    libgcc
    lua
  ];

  runtimeDependencies = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    libGL
    libx11
    libxcursor
    libxi
    libxkbcommon
    wayland
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Verilog to Factorio";
    longDescription = ''
      The purpose of this tool is to allow Factorio players to use
      Verilog to describe combinator circuits.  An additional purpose
      is to provide a simple API for describing combinators, so
      players can manually create designs.

      - Take a Verilog file and outputs json blueprint strings that
        can be imported in Factorio 2.0.
      - Exposes a Rust and Lua API for players to make designs in
        code.
    '';
    homepage = "https://github.com/ben-j-c/verilog2factorio";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "v2f";
  };
})

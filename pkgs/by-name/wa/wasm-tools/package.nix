{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wasm-tools";
  version = "1.246.2";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasm-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8HY11HNUm3GACNEr1OA438GSv9rVlgj4lsKiJVI31Dw=";
    fetchSubmodules = true;
  };

  # Disable cargo-auditable until https://github.com/rust-secure-code/cargo-auditable/issues/124 is solved.
  auditable = false;

  cargoHash = "sha256-DcIwKKzwzQvjToOTw9vQMuJbNCo9I7BwUigpJOa3Dm0=";
  cargoBuildFlags = [
    "--package"
    "wasm-tools"
  ];
  cargoTestFlags = [
    "--workspace"
    "--exclude"
    "wit-dylib"
  ]
  ++
    # Due to https://github.com/bytecodealliance/wasm-tools/issues/1820
    [
      "--"
      "--test-threads=1"
    ];

  meta = {
    description = "Low level tooling for WebAssembly in Rust";
    homepage = "https://github.com/bytecodealliance/wasm-tools";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ereslibre ];
    mainProgram = "wasm-tools";
  };
})

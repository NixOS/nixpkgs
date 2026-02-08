{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wasm-tools";
  version = "1.244.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasm-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XZ3X+KTfiYdUP4jMlkjDpapTOGBucgTmmQoOzizPG+s=";
    fetchSubmodules = true;
  };

  # Disable cargo-auditable until https://github.com/rust-secure-code/cargo-auditable/issues/124 is solved.
  auditable = false;

  cargoHash = "sha256-D/oz2Ow+MehQKdiP1/2Vb7BBDt1hib6tgoL1ulWWGHU=";
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

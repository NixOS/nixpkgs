{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-tools";
  version = "1.243.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasm-tools";
    tag = "v${version}";
    hash = "sha256-wVIGwFWQvQvFl170I0VgYaTvaJnOGv6GrtM6VGpPxSc=";
    fetchSubmodules = true;
  };

  # Disable cargo-auditable until https://github.com/rust-secure-code/cargo-auditable/issues/124 is solved.
  auditable = false;

  cargoHash = "sha256-9BYethBg9seBOCCJTLYvAXDXj2dfjSZWPBOQS1TqD90=";
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
}

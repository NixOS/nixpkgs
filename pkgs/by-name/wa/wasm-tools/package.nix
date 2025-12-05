{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-tools";
  version = "1.242.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasm-tools";
    tag = "v${version}";
    hash = "sha256-7TKodssE1obD7tIqrjrWoEdcCk3iSRwaecRHg7ddg6w=";
    fetchSubmodules = true;
  };

  # Disable cargo-auditable until https://github.com/rust-secure-code/cargo-auditable/issues/124 is solved.
  auditable = false;

  cargoHash = "sha256-X9dDmHWBdh0znGvTWG+WyiXmf4wnz5mhxJWsZJJUYmI=";
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

  meta = with lib; {
    description = "Low level tooling for WebAssembly in Rust";
    homepage = "https://github.com/bytecodealliance/wasm-tools";
    license = licenses.asl20;
    maintainers = with maintainers; [ ereslibre ];
    mainProgram = "wasm-tools";
  };
}

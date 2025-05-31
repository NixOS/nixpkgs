{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-tools";
  version = "1.232.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasm-tools";
    rev = "v${version}";
    hash = "sha256-iEHZXxE/cOs438KVXJ5o7+LobrODKtXGt92TPKxtOpU=";
    fetchSubmodules = true;
  };

  # Disable cargo-auditable until https://github.com/rust-secure-code/cargo-auditable/issues/124 is solved.
  auditable = false;
  useFetchCargoVendor = true;
  cargoHash = "sha256-W01pqmqJWwEOLv/ng0ZRFcPpOPO9s0IqcaEM7IN7v9g=";
  cargoBuildFlags = [
    "--package"
    "wasm-tools"
  ];
  cargoTestFlags =
    [ "--all" ]
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

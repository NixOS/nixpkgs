{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-tools";
  version = "1.220.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gXwdY75tTx57khF52LfNTIbacP53uxr/+YSc2zFiGSk=";
    fetchSubmodules = true;
  };

  # Disable cargo-auditable until https://github.com/rust-secure-code/cargo-auditable/issues/124 is solved.
  auditable = false;
  cargoHash = "sha256-bnFkeIzn8hHU7ABli8CVs+HeECqgc28nCKvdGN0Hr8s=";
  cargoBuildFlags = [ "--package" "wasm-tools" ];
  cargoTestFlags = [ "--all" ] ++
    # Due to https://github.com/bytecodealliance/wasm-tools/issues/1820
    [ "--" "--test-threads=1" ];

  meta = with lib; {
    description = "Low level tooling for WebAssembly in Rust";
    homepage = "https://github.com/bytecodealliance/wasm-tools";
    license = licenses.asl20;
    maintainers = with maintainers; [ ereslibre ];
    mainProgram = "wasm-tools";
  };
}

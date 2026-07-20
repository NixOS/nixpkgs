{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wasm-tools";
  version = "1.253.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasm-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z17Y6bqsAkZ25Rkbtx7g0x2R9+tllYrpumLkgL13gjI=";
    fetchSubmodules = true;
  };

  # Disable cargo-auditable until https://github.com/rust-secure-code/cargo-auditable/issues/124 is solved.
  auditable = false;

  cargoHash = "sha256-mBp9QbjEpwT3v0Bmvur+HTUOncSNYkqmfoyORzEqR+k=";
  cargoBuildFlags = [
    "--package"
    "wasm-tools"
  ];
  cargoTestFlags = [
    "--workspace"
    "--exclude"
    "wit-dylib"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd wasm-tools \
      --bash <($out/bin/wasm-tools completion bash) \
      --fish <($out/bin/wasm-tools completion fish) \
      --zsh <($out/bin/wasm-tools completion zsh)
  '';

  meta = {
    description = "Low level tooling for WebAssembly in Rust";
    homepage = "https://github.com/bytecodealliance/wasm-tools";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ereslibre ];
    mainProgram = "wasm-tools";
  };
})

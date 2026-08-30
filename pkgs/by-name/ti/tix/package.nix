{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tix";
  version = "0-unstable-2026-04-07";

  src = fetchFromGitHub {
    owner = "JRMurr";
    repo = "tix";
    rev = "6088dff2cc837ebf5e8c99494d7af8cc87150859";
    hash = "sha256-Zt0gSt/C1M4ue7K+CjcEyXk4+ox8m+AD3pDArOP2GAs=";
  };

  cargoHash = "sha256-6fPg5hvbBLDMnIHalJL1oTkKFrTCB4IDnCRYGa94J9E=";

  # Disabling failing tests:
  # - thread 'generate_module_stub_from_evalmodules_and_use_it' (12980) panicked at crates/cli/tests/custom_stubs.rs:39:10:
  # - thread 'formatting_returns_edits' (14384) panicked at crates/lsp/tests/e2e_formatting.rs:23:23:
  checkFlags = [
    "--skip=generate_module_stub_from_evalmodules_and_use_it"
    "--skip=formatting_returns_edits"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A nix type checker/lsp";
    homepage = "https://github.com/JRMurr/tix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "tix";
  };
})

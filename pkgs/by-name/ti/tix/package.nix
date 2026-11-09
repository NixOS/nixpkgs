{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tix";
  version = "0-unstable-2026-08-31";

  src = fetchFromGitHub {
    owner = "JRMurr";
    repo = "tix";
    rev = "ccb804fa81e457e3ab4b528a6c7a7cded6addd42";
    hash = "sha256-nwIuN26+odykj9fFDU/eadeZckzzZt6iCHF2mcmPp9E=";
  };

  cargoHash = "sha256-ZlEPXz65u8zikyFZppAH9W49hVFDdjIYey+H0OZQrUk=";

  # Disabling failing tests:
  # - thread 'generate_module_stub_from_evalmodules_and_use_it' (12980) panicked at crates/cli/tests/custom_stubs.rs:39:10:
  # - thread 'formatting_returns_edits' (14384) panicked at crates/lsp/tests/e2e_formatting.rs:23:23:
  checkFlags = [
    "--skip=generate_module_stub_from_evalmodules_and_use_it"
    "--skip=formatting_returns_edits"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nix type checker/lsp";
    homepage = "https://github.com/JRMurr/tix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "tix";
  };
})

{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wasm-server-runner";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "jakobhellermann";
    repo = "wasm-server-runner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3ARVVA+W9IS+kpV8j5lL/z6/ZImDaA+m0iEEQ2mSiTw=";
  };

  cargoHash = "sha256-FrnCmfSRAePZuWLC1/iRJ87CwLtgWRpbk6nJLyQQIT8=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cargo run for the browser";
    mainProgram = "wasm-server-runner";
    homepage = "https://github.com/jakobhellermann/wasm-server-runner";
    changelog = "https://github.com/jakobhellermann/wasm-server-runner/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.robwalt ];
  };
})

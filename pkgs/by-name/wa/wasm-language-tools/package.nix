{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wasm-language-tools";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "g-plane";
    repo = "wasm-language-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2v5rIp1QP6A631wYk8azGB3Jrf20v6qvP23p/y5lAgA=";
  };

  cargoHash = "sha256-Oit0rG0YrizFJk+KSyzXHEMOHI7eUXPyo1/wj0YY8WU=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/wat_server";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server and other tools for WebAssembly";
    homepage = "https://github.com/g-plane/wasm-language-tools/";
    changelog = "https://github.com/g-plane/wasm-language-tools/releases/tag/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "wat_server";
  };
})

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-language-tools";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "g-plane";
    repo = "wasm-language-tools";
    tag = "v${version}";
    hash = "sha256-6lZBDBjqHIMLMrWsnFeGuaGZDe3LKyBbbMbyvS3i29M=";
  };

  cargoHash = "sha256-npVrDGvTqKk9NkMiuWnSJRFEWfG9pGA7LEUrorNJ978=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/wat_server";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server and other tools for WebAssembly";
    homepage = "https://github.com/g-plane/wasm-language-tools/";
    changelog = "https://github.com/g-plane/wasm-language-tools/releases/tag/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "wat_server";
  };
}

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  _experimental-update-script-combinators,
  nix-update-script,
  vscode-extension-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wasm-language-tools";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "g-plane";
    repo = "wasm-language-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0E4bifmjx0sr9pp8vycqS0EcTI73A90hiyLTAlkw954=";
  };

  cargoHash = "sha256-nN07OSzq29Z08o0s5ozGQAI0Dh/125UmFO7G+28B8Qc=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/wat_server";
  doInstallCheck = true;

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (nix-update-script { })
    (vscode-extension-update-script {
      attrPath = "vscode-extensions.gplane.wasm-language-tools";
      extraArgs = [
        "--override-filename"
        "pkgs/applications/editors/vscode/extensions/gplane.wasm-language-tools/default.nix"
      ];
    })
  ];

  meta = {
    description = "Language server and other tools for WebAssembly";
    homepage = "https://github.com/g-plane/wasm-language-tools/";
    changelog = "https://github.com/g-plane/wasm-language-tools/releases/tag/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "wat_server";
  };
})

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  versionCheckHook,
  _experimental-update-script-combinators,
  nix-update-script,
  vscode-extension-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wasm-language-tools";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "g-plane";
    repo = "wasm-language-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XyVWNhVDo190/hnKj6A5dDYnlO9/WI0GYJIrkyfUkTw=";
  };

  patches = [
    # Fix test for Rust 1.98: https://github.com/rust-lang/rust/pull/155527
    (fetchpatch {
      name = "update-snapshot-for-rust-1.98.patch";
      url = "https://github.com/g-plane/wasm-language-tools/commit/d7cabdba9fa90ec74a461dcc6b470288184d6c86.patch";
      hash = "sha256-dPPMebvNVVtFTURsxGGHTwZ6SM3CDMlZucENzwOO6/4=";
    })
  ];

  cargoHash = "sha256-VoApXHdD8SF8ZqnDVynxunjVoZ5WKai2Xzw0UYy7hSg=";

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

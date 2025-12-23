{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wkg";
  version = "0.13.0";
  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasm-pkg-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6adUBw3jtmEq1y+hdnE7EBMgF5KChXr2MtOiSEPi1Ao=";
  };

  cargoHash = "sha256-BAHdOrLrSspSN1WsCtglCOQebI39zw6Byj9EgvU3onA=";

  # A large number of tests require Internet access in order to function.
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tools to package up WASM Components";
    homepage = "https://github.com/bytecodealliance/wasm-pkg-tools";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ water-sucks ];
    mainProgram = "wkg";
  };
})

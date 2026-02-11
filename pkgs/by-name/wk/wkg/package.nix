{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wkg";
  version = "0.14.0";
  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasm-pkg-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nFPfDVs/C7GtmLKy4V+ECsZvsABNfaxR3iDbDrnlMek=";
  };

  cargoHash = "sha256-KfF9VePqkWVdDU5C8b7x9u+uXPnrO5wVxQQZz8eJ4vM=";

  # A large number of tests require Internet access in order to function.
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tools to package up WASM Components";
    homepage = "https://github.com/bytecodealliance/wasm-pkg-tools";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ water-sucks ];
    mainProgram = "wkg";
  };
})

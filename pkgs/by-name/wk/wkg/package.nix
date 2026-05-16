{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wkg";
  version = "0.15.0";
  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasm-pkg-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G576caJ9oeYDFDIOP75mfkw6/JsxYyfDsVlFhb0RbIE=";
  };

  cargoHash = "sha256-3sf6fyLaiB/w6PF6CzO7p9ZHdBTLAzqIHEhT4COY/4A=";

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

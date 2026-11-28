{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wkg";
  version = "0.16.1";
  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasm-pkg-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bOspaM4RxU83Z3z9a29rYcbRPb9UyW4PXQAj3BE0A8s=";
  };

  cargoHash = "sha256-+ZBAagzPkg8rMNRSNsFIEmeIjBSx95q6AVFFjJp3wsM=";

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

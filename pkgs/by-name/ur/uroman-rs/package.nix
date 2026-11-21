{
  lib,
  rustPlatform,
  fetchCrate,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uroman-rs";
  version = "0.7.0";
  __structuredAttrs = true;

  src = fetchCrate {
    inherit (finalAttrs) version;
    crateName = "uroman";
    hash = "sha256-9aQOi4fHUswPFZRB/K3sFjVbcllhZPMxRRLJFDL87ZI=";
  };

  cargoHash = "sha256-NCUOoU6oLW9SffoSd6UxwF3r3GWdw4N9t7/i5eb4Wgs=";

  buildFeatures = [ "cli" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rust reimplementation of uroman, a universal romanizer";
    homepage = "https://github.com/o24s/uroman-rs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "uroman-rs";
  };
})

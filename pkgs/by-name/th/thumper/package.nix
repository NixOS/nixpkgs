{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "thumper";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "kaaveland";
    repo = "thumper";
    tag = "${finalAttrs.version}";
    hash = "sha256-+W4dBtvqCobxeFa+Zux1/dYVQoO17SscYR8FoAS7KLM=";
  };

  cargoHash = "sha256-m8B0+w0BddK8wQgaFfVUUPYdSDvqfs++A0a0WTIF5Qo=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tool to sync files from a local folder into a folder in a BunnyCDN Storage Zone";
    homepage = "https://github.com/kaaveland/thumper";
    changelog = "https://github.com/kaaveland/thumper/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ stv0g ];
    platforms = lib.platforms.all;
    mainProgram = "thumper";
  };
})

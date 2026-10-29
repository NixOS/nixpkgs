{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "thumper";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "kaaveland";
    repo = "thumper";
    tag = "${finalAttrs.version}";
    hash = "sha256-6ZjtYS6CE1T7zdLPqILv8HUV8cyXWUGesW8MaYCGeyI=";
  };

  cargoHash = "sha256-H7QV0704bcD7dgkQot81gmtHFEtUccR25FmAK10pYaw=";

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

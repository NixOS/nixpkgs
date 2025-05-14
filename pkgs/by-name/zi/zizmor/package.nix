{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zizmor";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "zizmorcore";
    repo = "zizmor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HDQDaIZVxMTkVTwCNyevSdVZELw8e6hIN/NhaHLcT24=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-hr/1RFXvbsRLxlmXNPuU3x+i41byE+v5k2aBg5UIbvM=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for finding security issues in GitHub Actions setups";
    homepage = "https://docs.zizmor.sh/";
    changelog = "https://github.com/zizmorcore/zizmor/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lesuisse ];
    mainProgram = "zizmor";
  };
})

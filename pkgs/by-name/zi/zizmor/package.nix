{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zizmor";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = "zizmor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Has3PrXJIKQh6FdhZ3aGvqJ5keHTRqa+nDAb4fv3xWg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-uXUvEbQpY9E7kTOeXMFN/9b4u4tn/S3HCs0a65Hssn4=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for finding security issues in GitHub Actions setups";
    homepage = "https://woodruffw.github.io/zizmor/";
    changelog = "https://github.com/woodruffw/zizmor/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lesuisse ];
    mainProgram = "zizmor";
  };
})

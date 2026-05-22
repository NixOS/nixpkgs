{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tuistash";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "edmocosta";
    repo = "tuistash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-36IIQ0dA87tp+H2CKPvV5lWFz5o9J9b6ubQZFRAUMD0=";
  };

  cargoHash = "sha256-4qxV1sjzEWwVj1jCOcpBnqmWa+bVDUflfoQT1TL1FBQ=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal User Interface for Logstash";
    homepage = "https://github.com/edmocosta/tuistash";
    changelog = "https://github.com/edmocosta/tuistash/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = [ lib.licenses.asl20 ];
    maintainers = [ lib.maintainers.kpbaks ];
    mainProgram = "tuistash";
  };
})

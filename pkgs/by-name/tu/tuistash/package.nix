{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tuistash";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "edmocosta";
    repo = "tuistash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pyLsm3y2MwLJvscugAdKnw/+/Q0A52tAJ9MxUI5br90=";
  };

  cargoHash = "sha256-VLcB7CjelyESnwcWgoC8AdwiGTkuro+KqL+prOtnkLM=";

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

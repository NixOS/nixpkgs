{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tuistash";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "edmocosta";
    repo = "tuistash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LWmH/xHvdiY6lC7gsRh2gX31b9Fh4fWekrVdQ++8moQ=";
  };

  cargoHash = "sha256-mLtzdWHC7HN+hju71WQQZ4nJDMzybEfjzckbfeu32Qo=";

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

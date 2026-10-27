{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vy";
  version = "0.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ynqa";
    repo = "vy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sobAAhE8x4yAQNxbYxkrKQ6WcvFq2KENjkknctwyUAs=";
  };

  cargoHash = "sha256-z1GNcgEtTi831oeJgJNlhuWTgdu3gZid82dH/cMQCuA=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Explore and query JSON and YAML, right in your terminal";
    homepage = "https://vy.ynqa.dev";
    changelog = "https://github.com/ynqa/vy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ManUtopiK ];
    mainProgram = "vy";
  };
})

{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xssearch";
  version = "0.1.9";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "affolter-engineering";
    repo = "xssearch";
    tag = finalAttrs.version;
    hash = "sha256-09knkYBnIjZsdAlczYIeqtn0XGAvCD+RF3o9sGSUorw=";
  };

  cargoHash = "sha256-t+IcNrjHlVVKrYuLiRrlteT4jQLRiWUsj9RTTTflTiA=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Advanced XSS detection tool";
    homepage = "https://github.com/affolter-engineering/xssearch";
    changelog = "https://github.com/affolter-engineering/xssearch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "xssearch";
  };
})

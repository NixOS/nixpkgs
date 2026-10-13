{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xssearch";
  version = "0.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "affolter-engineering";
    repo = "xssearch";
    tag = finalAttrs.version;
    hash = "sha256-b0pS8iu6iIO1VwmHWp7yhZiP7ngbdrUz5PCz5NjHZTo=";
  };

  cargoHash = "sha256-uS4PJhBRUuvbRFafO7HSG7+b5cb8k0YDRWgy4Iz8JMU=";

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

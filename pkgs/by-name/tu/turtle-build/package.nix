{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "turtle-build";
  version = "0.5.16";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "turtle-build";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2B9QfOIS5a8YFh5DNvw4FdHQz3fQ15lqb/2b/1cUk3M=";
  };

  cargoHash = "sha256-/7uEbYjIBY5ggK+iLADz7mEp1ZfLR84jN1jMBWxYiKU=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Ninja-compatible build system for high-level programming languages written in Rust";
    homepage = "https://github.com/raviqqe/turtle-build";
    changelog = "https://github.com/raviqqe/turtle-build/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ lib.maintainers.progrm_jarvis ];
    mainProgram = "turtle";
  };
})

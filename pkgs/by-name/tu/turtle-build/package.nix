{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "turtle-build";
  version = "0.5.19";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "turtle-build";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ShlybH58Lnnp1B7jqGGmBl16VGvr1kFpkbcAXfEsniY=";
  };

  cargoHash = "sha256-oyydM8zE+RCG6R8azTONKkG5R5OCnIpi7uG51UVe9nQ=";

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

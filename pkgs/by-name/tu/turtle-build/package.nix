{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "turtle-build";
  version = "0.4.9";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "turtle-build";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sbYDp4r/M6GvCYEshccJ331mVNeN85wwf9TKHiYFv7I=";
  };

  cargoHash = "sha256-JZU0Xam4NPiOHdXDtJsTBjOQnaDWReSZMD33sQxeUzQ=";

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

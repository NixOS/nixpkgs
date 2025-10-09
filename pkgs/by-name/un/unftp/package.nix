{
  fetchFromGitHub,
  lib,
  nix-update-script,
  versionCheckHook,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "unftp";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "bolcom";
    repo = "unftp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M6+4AYE2Wls2+LoPx3LSLHIWgWu9SMOIaNLVbXWKqGY=";
  };

  cargoHash = "sha256-P3TjRzo1TJE1LW+jbF0HOWeVXYsvwaZ+5CI+kH4jZNQ=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "FTP(S) server with a couple of twists written in Rust";
    homepage = "https://unftp.rs/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aiyion ];
    mainProgram = "unftp";
  };
})

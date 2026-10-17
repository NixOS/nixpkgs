{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uroman-rs";
  version = "0.6.7";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fulm-o";
    repo = "uroman-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tGIjpReqQL91qLgrdnEscJV6zUXmPS/WB3HEAcbJPho=";
  };

  cargoHash = "sha256-JkrmOXKlN0gB045SPMymojW0/BCfMnuB+dVHRuCE0p8=";

  buildFeatures = [ "cli" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rust reimplementation of uroman, a universal romanizer";
    changelog = "https://github.com/fulm-o/uroman-rs/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/fulm-o/uroman-rs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "uroman-rs";
  };
})

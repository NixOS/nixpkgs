{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  docker,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wrkflw";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "bahdotsh";
    repo = "wrkflw";
    rev = "v${finalAttrs.version}";
    hash = "sha256-b2g6sY+YBZfD5D+fmbpz+hKZvKKwjCCuygxk2pyYaR8=";
  };

  cargoHash = "sha256-iCagvOIc1Gsox6yQDfOrSTXaM30Q93CwHZdDZOi4kK0=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    docker
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Validate and execute GitHub Actions workflows locally";
    homepage = "https://github.com/bahdotsh/wrkflw";
    changelog = "https://github.com/bahdotsh/wrkflw/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      awwpotato
      FKouhai
    ];
    mainProgram = "wrkflw";
  };
})

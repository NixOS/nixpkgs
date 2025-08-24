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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "bahdotsh";
    repo = "wrkflw";
    rev = "v${finalAttrs.version}";
    hash = "sha256-J0FlGuISBpyiZNQSwQF/9YJncu67BKSC2Bq2S6F/vKQ=";
  };

  cargoHash = "sha256-8iYsHVc7WI94IKMECYs4v+68rG3Mc8Kto9dmGwQrkCU=";

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

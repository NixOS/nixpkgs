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
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "bahdotsh";
    repo = "wrkflw";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VwB8qpCNyuB28XqIUJa+ghtZ4Dx1QYDluw6+zxtePIQ=";
  };

  cargoHash = "sha256-lZ2dcR33fzIUX8XvJMcysQWSViWD1hpm471wkpD22QA=";

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
      tebriel
    ];
    mainProgram = "wrkflw";
  };
})

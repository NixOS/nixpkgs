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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "bahdotsh";
    repo = "wrkflw";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ErzlAVRyDyRo/AAbTjuBhuQtveRttB0ArUugIGuYMiY=";
  };

  cargoHash = "sha256-SbX0jWaihabl90L7KfRfFakvTDIpJcDjsfOr36T8+Xg=";

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

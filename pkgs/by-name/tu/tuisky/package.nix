{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tuisky";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "sugyan";
    repo = "tuisky";
    tag = "v${finalAttrs.version}";
    hash = "sha256-isS3MDyQ3iv5fYAw/i9V905J+2QnMFx2bebA853fBd4=";
  };

  cargoHash = "sha256-coBP2uItI/PJv4Bt3ILDo4ruyqejGwWjaDw5DmxseXw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "TUI client for bluesky";
    homepage = "https://github.com/sugyan/tuisky";
    changelog = "https://github.com/sugyan/tuisky/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "tuisky";
  };
})

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "tuisky";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "sugyan";
    repo = "tuisky";
    rev = "refs/tags/v${version}";
    hash = "sha256-TsxERi+xxWk6SJwIxMgqiYCAUrDLzZXPL1xQCIXtUr0=";
  };

  cargoHash = "sha256-p6Yqg4HdkviuOuYMGEPXyySduiS47aPOshr5iXE+f+A=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "TUI client for bluesky";
    homepage = "https://github.com/sugyan/tuisky";
    changelog = "https://github.com/sugyan/tuisky/blob/${lib.removePrefix "refs/tags/" src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "tuisky";
  };
}

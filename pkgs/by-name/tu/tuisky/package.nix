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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "sugyan";
    repo = "tuisky";
    tag = "v${version}";
    hash = "sha256-s0eKWP4cga82Fj7KGIG6yLk67yOqGoAqfhvJINzytTw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-F/gEBEpcgNT0Q55zUTf8254yYIZI6RmiW9heCuljAEY=";

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
    changelog = "https://github.com/sugyan/tuisky/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "tuisky";
  };
}

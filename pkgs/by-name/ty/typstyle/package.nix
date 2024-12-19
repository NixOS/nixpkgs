{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "typstyle";
  version = "0.12.12";

  src = fetchFromGitHub {
    owner = "Enter-tainer";
    repo = "typstyle";
    tag = "v${version}";
    hash = "sha256-oQnZm+BkccHN3xXSe1yBus3m4JKyCBKM9kkJz+QryR0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-pbsB9mQafgI6PudjeCzOSpk3+iZkkdp/V1zgH8pP7us=";

  # Disabling tests requiring network access
  checkFlags = [
    "--skip=e2e"
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
    changelog = "https://github.com/Enter-tainer/typstyle/blob/${src.tag}/CHANGELOG.md";
    description = "Format your typst source code";
    homepage = "https://github.com/Enter-tainer/typstyle";
    license = lib.licenses.asl20;
    mainProgram = "typstyle";
    maintainers = with lib.maintainers; [ drupol ];
  };
}

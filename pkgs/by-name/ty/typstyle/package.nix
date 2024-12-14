{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "typstyle";
  version = "0.12.10";

  src = fetchFromGitHub {
    owner = "Enter-tainer";
    repo = "typstyle";
    tag = "v${version}";
    hash = "sha256-nrsfp0T4QYLZw5F5R4iTewUjlZOErc/15c0O6O9BFBE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-gPsZRdksX+7sZWK7V/q17oZmN2kgQkApC66/3KowDCI=";

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
    changelog = "https://github.com/Enter-tainer/typstyle/blob/v${version}/CHANGELOG.md";
    description = "Format your typst source code";
    homepage = "https://github.com/Enter-tainer/typstyle";
    license = lib.licenses.asl20;
    mainProgram = "typstyle";
    maintainers = with lib.maintainers; [ drupol ];
  };
}

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "typstyle";
  version = "0.12.14";

  src = fetchFromGitHub {
    owner = "Enter-tainer";
    repo = "typstyle";
    tag = "v${version}";
    hash = "sha256-TOu/1NiIofY87ttdBPDM2tVRg57FL8v8FCwkf0NFdBQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-2BX1Ol7eCWs7b5cIwQWWBwFksQ4HO7NmnoP9D384TUQ=";

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

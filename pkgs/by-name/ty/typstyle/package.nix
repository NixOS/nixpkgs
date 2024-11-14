{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "typstyle";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "Enter-tainer";
    repo = "typstyle";
    rev = "refs/tags/v${version}";
    hash = "sha256-liGGnaUhi3/d4SxpiG/P1wp89brqUJaLyo9/KJvPf9I=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "reflexo-0.5.0-rc7" = "sha256-XjzHo9HprI1FVPDwNQ0Gw9iTXspo6PUsxz3BOd6qkL0=";
    };
  };

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
    changelog = "https://github.com/Enter-tainer/typstyle/blob/${src.rev}/CHANGELOG.md";
    description = "Format your typst source code";
    homepage = "https://github.com/Enter-tainer/typstyle";
    license = lib.licenses.asl20;
    mainProgram = "typstyle";
    maintainers = with lib.maintainers; [ drupol ];
  };
}

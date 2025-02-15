{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.29.4";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "typos";
    tag = "v${version}";
    hash = "sha256-4cCXh6fysunsc6MNb7YNx+1I1tnYJkBgpA30P6IzTcM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ISz65YPKgQ7W4pC6KM87xPr6Xt1g+Ve0L5nqShS3Ujc=";

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "Source code spell checker";
    mainProgram = "typos";
    homepage = "https://github.com/crate-ci/typos";
    changelog = "https://github.com/crate-ci/typos/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      figsoda
      mgttlinger
    ];
  };
}

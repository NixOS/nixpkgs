{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.29.7";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "typos";
    tag = "v${version}";
    hash = "sha256-YCOSe0EsPQMvIF6wm1oqisAm7t7GUzL56D/TZcNMTIk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-d5s+reeZjLrRLPJOpWbe0grFsng74o4CmWgI6ln+614=";

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

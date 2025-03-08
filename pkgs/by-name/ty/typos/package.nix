{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.30.0";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "typos";
    tag = "v${version}";
    hash = "sha256-SFE6hieK2SU+Dmf0eDc35/INJKPoySUJBE9ES8KrCIg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Cnk/iLdkDyxoHU+vRxuLIyGkcqaGF8WjVOnhNoxg3T4=";

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

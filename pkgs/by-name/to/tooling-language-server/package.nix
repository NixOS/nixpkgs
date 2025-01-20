{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "tooling-language-server";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "filiptibell";
    repo = "tooling-language-server";
    tag = "v${version}";
    hash = "sha256-G6UuihmmcSFrP/rgmZg8yBY4ugkwQMOD6fgK8lqn+Es=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-gEHdlaj9Dz4XpQdmcdK3Fdla4y+8D0ugq7VFoOmKDwM=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A language server for tools & package managers";
    homepage = "https://github.com/filiptibell/tooling-language-server";
    changelog = "https://github.com/filiptibell/tooling-language-server/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ niklaskorz ];
    mainProgram = "tooling-language-server";
  };
}

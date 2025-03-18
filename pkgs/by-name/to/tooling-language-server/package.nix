{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "tooling-language-server";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "filiptibell";
    repo = "tooling-language-server";
    tag = "v${version}";
    hash = "sha256-0FF9p3Z8C3C/fcTvu66ozCs/G3UAJ/Kf2v+4IZU4eCA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-DxQMAnlE8oWtigU1gUEdTdBIvEtbL8xhaPLx6kt8T2c=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server for tools and package managers";
    homepage = "https://github.com/filiptibell/tooling-language-server";
    changelog = "https://github.com/filiptibell/tooling-language-server/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ niklaskorz ];
    mainProgram = "tooling-language-server";
  };
}

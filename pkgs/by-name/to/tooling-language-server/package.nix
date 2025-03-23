{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "tooling-language-server";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "filiptibell";
    repo = "tooling-language-server";
    tag = "v${version}";
    hash = "sha256-4jwL2XD4bK3QnsQ/nOLySjp6e5nGB8jUOf6reYzNrAc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-L7LfnF9C6JNjY9pGJb0uuj38H9KI3vkkvtx7QCB1GO0=";

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

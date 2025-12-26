{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "tombl";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "snyball";
    repo = "tombl";
    tag = "v${version}";
    hash = "sha256-XHvAgJ8/+ZkBxwZpMgaDchr0hBa1FXAd/j1+HH9N6qw=";
  };

  cargoHash = "sha256-A3zdDzmwX2gdTLLWnUGeiqY1R5PBKZRmEHdIi1Uveaw=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Easily query TOML files from bash";
    homepage = "https://github.com/snyball/tombl";
    changelog = "https://github.com/snyball/tombl/releases/tag/v${version}";
    mainProgram = "tombl";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ oskardotglobal ];
  };
}

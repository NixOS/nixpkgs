{
  lib,
  fetchFromGitHub,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phpinsights";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "nunomaduro";
    repo = "phpinsights";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XuvwO/MkGBMWo2hjDPDDYS3JmfWJH75mbNn6oKsMWps=";
  };

  composerLock = ./composer.lock;
  vendorHash = "sha256-uy8/bkgjDXnt544S70IOwX9I8U0lMLAkbiBDYXyJBcY=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    broken = lib.versionOlder php.version "8.2";
    changelog = "https://github.com/nunomaduro/phpinsights/releases/tag/v${finalAttrs.version}";
    description = "Instant PHP quality checks from your console";
    homepage = "https://phpinsights.com/";
    license = lib.licenses.mit;
    mainProgram = "phpinsights";
    teams = [ lib.teams.php ];
  };
})

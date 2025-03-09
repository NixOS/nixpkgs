{
  lib,
  fetchFromGitHub,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phpinsights";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "nunomaduro";
    repo = "phpinsights";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XuvwO/MkGBMWo2hjDPDDYS3JmfWJH75mbNn6oKsMWps=";
  };

  vendorHash = "sha256-xeruE3oCrl6usg/7Wmop/w/CrIZfT+zMTQiQJXtBExw=";

  composerLock = ./composer.lock;

  meta = {
    changelog = "https://github.com/nunomaduro/phpinsights/releases/tag/v${finalAttrs.version}";
    description = "Instant PHP quality checks from your console";
    homepage = "https://phpinsights.com/";
    license = lib.licenses.mit;
    mainProgram = "phpinsights";
    maintainers = [ ];
  };
})

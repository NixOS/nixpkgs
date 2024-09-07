{
  lib,
  fetchFromGitHub,
  php,
}:

php.buildComposerProject (finalAttrs: {
  pname = "phpinsights";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "nunomaduro";
    repo = "phpinsights";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7ATlfAlCFv78JSKg5cD/VcYoq/EAM/6/GjH3lkfVCJ8=";
  };

  vendorHash = "sha256-MOq7xmX8wqDk9W3M2gkejyXXPTcVFFgU0ohmDpL0Tvg=";

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

{ lib, fetchgit, php82 }:

php82.buildComposerProject (finalAttrs: {
  pname = "psalm";
  version = "5.21.1";

  src = fetchgit {
    url = "https://github.com/vimeo/psalm.git";
    rev = finalAttrs.version;
    hash = "sha256-sOGndJEDPRBanj3ngwNWZsTs5yPwVc8n2Bd+hFBwUSk=";
  };

  # TODO: Open a PR against https://github.com/vimeo/psalm
  # Missing `composer.lock` from the repository.
  composerLock = ./composer.lock;
  vendorHash = "sha256-zwSLyxEZFoXM/1a8Pr7c/+xaYzAYj51fjKk/LDj/rYo=";

  meta = {
    changelog = "https://github.com/vimeo/psalm/releases/tag/${finalAttrs.version}";
    description = "A static analysis tool for finding errors in PHP applications";
    homepage = "https://github.com/vimeo/psalm";
    license = lib.licenses.mit;
    mainProgram = "psalm";
    maintainers = lib.teams.php.members;
  };
})

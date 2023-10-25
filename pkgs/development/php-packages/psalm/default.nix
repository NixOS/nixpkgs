{ lib, fetchgit, php }:

php.buildComposerProject (finalAttrs: {
  pname = "psalm";
  version = "5.15.0";

  src = fetchgit {
    url = "https://github.com/vimeo/psalm.git";
    rev = finalAttrs.version;
    hash = "sha256-rRExT82+IwgVo7pL3rrTjW/qj/MJf4m4L3PywaeSHYU=";
  };

  # TODO: Open a PR against https://github.com/vimeo/psalm
  # Missing `composer.lock` from the repository.
  composerLock = ./composer.lock;
  vendorHash = "sha256-Vho1ri/Qm2SYeXB9ZoXvH1vB/eSBwHnAT/pI4jjUYhU=";

  meta = {
    changelog = "https://github.com/vimeo/psalm/releases/tag/${finalAttrs.version}";
    description = "A static analysis tool for finding errors in PHP applications";
    homepage = "https://github.com/vimeo/psalm";
    license = lib.licenses.mit;
    maintainers = lib.teams.php.members;
  };
})

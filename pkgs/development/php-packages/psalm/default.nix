{
  lib,
  fetchFromGitHub,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "psalm";
  version = "5.26.1";

  src = fetchFromGitHub {
    owner = "vimeo";
    repo = "psalm";
    tag = finalAttrs.version;
    hash = "sha256-TZm7HByPoCB4C0tdU5rzTfjMQEnhRhWPEiNR0bQDkTs=";
  };

  # Missing `composer.lock` from the repository.
  # Issue open at https://github.com/vimeo/psalm/issues/10446
  composerLock = ./composer.lock;
  vendorHash = "sha256-po43yrMlvX7Y91Z3D5IYSpY7FOS6+tL/+a3AozopZ9Q=";

  meta = {
    changelog = "https://github.com/vimeo/psalm/releases/tag/${finalAttrs.version}";
    description = "Static analysis tool for finding errors in PHP applications";
    homepage = "https://github.com/vimeo/psalm";
    license = lib.licenses.mit;
    mainProgram = "psalm";
    maintainers = lib.teams.php.members;
  };
})

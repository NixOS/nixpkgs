{
  lib,
  fetchFromGitHub,
  php,
}:

php.buildComposerProject (finalAttrs: {
  pname = "psalm";
  version = "5.22.2";

  src = fetchFromGitHub {
    owner = "vimeo";
    repo = "psalm";
    rev = finalAttrs.version;
    hash = "sha256-M8Ds3PQGphK8lQciWNdxWkMN35q8vdaNTWTrP1WXTeg=";
  };

  # Missing `composer.lock` from the repository.
  # Issue open at https://github.com/vimeo/psalm/issues/10446
  composerLock = ./composer.lock;
  vendorHash = "sha256-AgvAaHcCYosS3yRrp9EFdqTjg6NzQRCr8ELSza9DvZ8=";

  meta = {
    changelog = "https://github.com/vimeo/psalm/releases/tag/${finalAttrs.version}";
    description = "Static analysis tool for finding errors in PHP applications";
    homepage = "https://github.com/vimeo/psalm";
    license = lib.licenses.mit;
    mainProgram = "psalm";
    maintainers = lib.teams.php.members;
  };
})

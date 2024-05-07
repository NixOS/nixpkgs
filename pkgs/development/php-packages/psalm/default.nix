{
  lib,
  fetchFromGitHub,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "psalm";
  version = "5.22.2";

  src = fetchFromGitHub {
    owner = "vimeo";
    repo = "psalm";
    rev = finalAttrs.version;
    hash = "sha256-27CdDg6DDgGTx+V+oso2keCyXLDrHwAYcegrxvgotgQ=";
  };

  # Missing `composer.lock` from the repository.
  # Issue open at https://github.com/vimeo/psalm/issues/10446
  composerLock = ./composer.lock;
  vendorHash = "sha256-d7+GJ/Tc03tPhCPVXhYKvkkhVkcrBlIMA7vjMqTaX3c=";

  meta = {
    changelog = "https://github.com/vimeo/psalm/releases/tag/${finalAttrs.version}";
    description = "Static analysis tool for finding errors in PHP applications";
    homepage = "https://github.com/vimeo/psalm";
    license = lib.licenses.mit;
    mainProgram = "psalm";
    maintainers = lib.teams.php.members;
  };
})

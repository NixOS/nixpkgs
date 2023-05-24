{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "psalm";
  version = "5.13.1";

  src = fetchFromGitHub {
    owner = "vimeo";
    repo = "psalm";
    rev = finalAttrs.version;
    hash = "sha256-pFQ1MGo85Z5WTnBJCppMCMpcrE+PdRzqqaZRi/ZLNlA=";
  };

  # TODO: Open a PR against https://github.com/vimeo/psalm
  # Missing `composer.lock` from the repository.
  composerLock = ./composer.lock;
  vendorHash = "sha256-4FFo5/sAJzU1n3wvSeP34ocBnXMBIraD7xrf+lcDHp0=";

  meta = {
    changelog = "https://github.com/vimeo/psalm/releases/tag/${finalAttrs.version}";
    description = "A static analysis tool for finding errors in PHP applications";
    homepage = "https://github.com/vimeo/psalm";
    license = lib.licenses.mit;
    maintainers = lib.teams.php.members;
  };
})

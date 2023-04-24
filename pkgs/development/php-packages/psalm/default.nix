{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "psalm";
  version = "5.11.0";

  src = fetchFromGitHub {
    owner = "vimeo";
    repo = "psalm";
    rev = finalAttrs.version;
    hash = "sha256-0Qkbz+XyaE/kwJsXHl896DNF7rMlsTZb17xIzg1RW/U=";
  };

  # TODO: Open a PR against https://github.com/sebastianbergmann/phpunit
  # Missing `composer.lock` from the repository.
  composerLock = ./composer.lock;
  vendorHash = "sha256-f4hlAaEah6u9FJ6/G7pj7pHLVnP0oAGFhdZLKpNqdQ8=";

  meta = {
    changelog = "https://github.com/vimeo/psalm/releases/tag/${finalAttrs.version}";
    description = "A static analysis tool for finding errors in PHP applications";
    license = lib.licenses.mit;
    homepage = "https://github.com/vimeo/psalm";
    maintainers = lib.teams.php.members;
  };
})

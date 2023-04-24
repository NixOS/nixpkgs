{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "psalm";
  version = "5.10.0";

  src = fetchFromGitHub {
    owner = "vimeo";
    repo = "psalm";
    rev = finalAttrs.version;
    hash = "sha256-JFOLs3D7KBGZhMV+wxTf1Ma2JQUSJj+mXDBjFe9Lfh4=";
  };

  # TODO: Open a PR against https://github.com/sebastianbergmann/phpunit
  # Missing `composer.lock` from the repository.
  composerLock = ./composer.lock;
  vendorHash = "sha256-f4hlAaEah6u9FJ6/G7pj7pHLVnP0oAGFhdZLKpNqdQ8=";

  meta = with lib; {
    changelog = "https://github.com/vimeo/psalm/releases/tag/${version}";
    description = "A static analysis tool for finding errors in PHP applications";
    license = licenses.mit;
    homepage = "https://github.com/vimeo/psalm";
    maintainers = teams.php.members;
  };
})

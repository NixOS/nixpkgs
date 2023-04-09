{ fetchFromGitHub, fetchurl, lib, php }:

php.buildComposerProject (finalAttrs: {
  pname = "grumphp";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "phpro";
    repo = "grumphp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gQs05nrKh1A6N6xmoPayqoqFZdV2zK/2UAg6ZkpDzBs=";
  };

  composerLock = fetchurl {
    url = "https://github.com/phpro/grumphp-shim/raw/695f2f0be5f2790242c362e8b79d3f92c276c9a1/phar.composer.lock";
    hash = "sha256-XeWDUQUnUEOCtT+wjmR0kXikGHdE336KXglTfzfVVQo=";
  };
  vendorHash = "sha256-ZZ7fmsgCLH3nmSU9tE5F66u7XkaayRCEGyZnQdVGFYs=";

  meta = {
    changelog = "https://github.com/phpro/grumphp/releases/tag/v${finalAttrs.version}";
    description = "A PHP code-quality tool";
    homepage = "https://github.com/phpro/grumphp";
    license = lib.licenses.mit;
    maintainers = lib.teams.php.members;
  };
})

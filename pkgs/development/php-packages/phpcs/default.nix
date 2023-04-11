{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "phpcs";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "squizlabs";
    repo = "PHP_CodeSniffer";
    rev = finalAttrs.version;
    hash = "sha256-EJF9e8gyUy5SZ+lmyWFPAabqnP7Fy5t80gfXWWxLpk8=";
  };

  # TODO: Open a PR against https://github.com/squizlabs/PHP_CodeSniffer
  # Missing `composer.lock` from the repository.
  composerLock = ./composer.lock;
  vendorHash = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";

  meta = with lib; {
    changelog = "https://github.com/squizlabs/PHP_CodeSniffer/releases/tag/${finalAttrs.version}";
    description = "PHP coding standard tool";
    license = licenses.bsd3;
    homepage = "https://squizlabs.github.io/PHP_CodeSniffer/";
    maintainers = with maintainers; [ javaguirre ] ++ teams.php.members;
  };
})

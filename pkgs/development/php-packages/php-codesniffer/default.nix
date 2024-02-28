{ fetchFromGitHub
, lib
, php
}:

php.buildComposerProject (finalAttrs: {
  pname = "php-codesniffer";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "squizlabs";
    repo = "PHP_CodeSniffer";
    rev = "${finalAttrs.version}";
    hash = "sha256-EJF9e8gyUy5SZ+lmyWFPAabqnP7Fy5t80gfXWWxLpk8=";
  };

  composerLock = ./composer.lock;
  vendorHash = "sha256-svkQEKKFa0yFTiOihnAzVdi3oolq3r6JmlugyBZJATA=";

  meta = {
    changelog = "https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/tag/${finalAttrs.version}";
    description = "PHP coding standard tool";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/PHPCSStandards/PHP_CodeSniffer/";
    maintainers = with lib.maintainers; [ javaguirre ] ++ lib.teams.php.members;
  };
})

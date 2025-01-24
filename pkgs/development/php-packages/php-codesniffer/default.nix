{
  fetchFromGitHub,
  lib,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "php-codesniffer";
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "PHPCSStandards";
    repo = "PHP_CodeSniffer";
    rev = "${finalAttrs.version}";
    hash = "sha256-zCAaXKlKIBF7LK+DHkbzOqnSMj+ZaeafZnSOHOq3Z5Q=";
  };

  composerLock = ./composer.lock;
  vendorHash = "sha256-r40bINMa9n4Rzlv75QSuz0TiV5qGsdh4mwMqj9BsKTY=";

  meta = {
    changelog = "https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/tag/${finalAttrs.version}";
    description = "PHP coding standard tool";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/PHPCSStandards/PHP_CodeSniffer/";
    maintainers = with lib.maintainers; [ javaguirre ] ++ lib.teams.php.members;
  };
})

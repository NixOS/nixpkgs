{
  fetchFromGitHub,
  lib,
  php,
}:

php.buildComposerProject (finalAttrs: {
  pname = "php-codesniffer";
  version = "3.9.0";

  src = fetchFromGitHub {
    owner = "PHPCSStandards";
    repo = "PHP_CodeSniffer";
    rev = "${finalAttrs.version}";
    hash = "sha256-HyAb0vfruJWch09GVWtKI+NOTpsUkkLRusFSwZlNHjA=";
  };

  composerLock = ./composer.lock;
  vendorHash = "sha256-nM0sKdD+fc3saPCvU+0KI7HM+LdSi0vJIoutwuZnx/Y=";

  meta = {
    changelog = "https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/tag/${finalAttrs.version}";
    description = "PHP coding standard tool";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/PHPCSStandards/PHP_CodeSniffer/";
    maintainers = with lib.maintainers; [ javaguirre ] ++ lib.teams.php.members;
  };
})

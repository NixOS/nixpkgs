{
  fetchFromGitHub,
  lib,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "php-codesniffer";
  version = "3.11.2";

  src = fetchFromGitHub {
    owner = "PHPCSStandards";
    repo = "PHP_CodeSniffer";
    tag = "${finalAttrs.version}";
    hash = "sha256-/rUkAQvdVMjeIS9UIKjTgk2D9Hb6HfQBRUXqbDYTAmg=";
  };

  vendorHash = "sha256-t5v+HyzOwa6+z5+PtEAAs9wSKxNBZ++tNc2iGO3tspY=";

  meta = {
    changelog = "https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/tag/${finalAttrs.version}";
    description = "PHP coding standard tool";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/PHPCSStandards/PHP_CodeSniffer/";
    maintainers = with lib.maintainers; [ javaguirre ] ++ lib.teams.php.members;
  };
})

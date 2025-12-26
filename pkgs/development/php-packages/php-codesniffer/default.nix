{
  fetchFromGitHub,
  lib,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "php-codesniffer";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "PHPCSStandards";
    repo = "PHP_CodeSniffer";
    tag = finalAttrs.version;
    hash = "sha256-2fubJMn44pS+++QgK66vm4YTT+0zdgtAJVHKvvWO/QA=";
  };

  vendorHash = "sha256-t+cNnrs/4xzIDg3qM/MIRyu1Ulen03s2asZ2JuOxQgI=";

  meta = {
    changelog = "https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/tag/${finalAttrs.version}";
    description = "PHP coding standard tool";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/PHPCSStandards/PHP_CodeSniffer/";
    maintainers = with lib.maintainers; [ javaguirre ];
    teams = [ lib.teams.php ];
  };
})

{
  fetchFromGitHub,
  lib,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "php-codesniffer";
  version = "4.0.4";

  src = fetchFromGitHub {
    owner = "PHPCSStandards";
    repo = "PHP_CodeSniffer";
    tag = finalAttrs.version;
    hash = "sha256-ZBiPTjDnnjaRWXzqB7soJsvJgU06GU79VzwsfEA9NhI=";
  };

  vendorHash = "sha256-qLYXFgY5cg2Fz33lrhwHHoqmbmtZo81ngVuUFh6N648=";

  meta = {
    changelog = "https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/tag/${finalAttrs.version}";
    description = "PHP coding standard tool";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/PHPCSStandards/PHP_CodeSniffer/";
    maintainers = with lib.maintainers; [ javaguirre ];
    teams = [ lib.teams.php ];
  };
})

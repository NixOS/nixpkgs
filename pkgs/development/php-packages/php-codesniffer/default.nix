{
  fetchFromGitHub,
  lib,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "php-codesniffer";
  version = "3.11.3";

  src = fetchFromGitHub {
    owner = "PHPCSStandards";
    repo = "PHP_CodeSniffer";
    tag = "${finalAttrs.version}";
    hash = "sha256-yOi3SFBZfE6WhmMRHt0z86UJPnDnc9hXHtzYe5Ess6c=";
  };

  vendorHash = "sha256-XAyRbfISIpIa4H9IX4TvpDnHhLj6SdqyKlpyG68mnUM=";

  meta = {
    changelog = "https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/tag/${finalAttrs.version}";
    description = "PHP coding standard tool";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/PHPCSStandards/PHP_CodeSniffer/";
    maintainers = with lib.maintainers; [ javaguirre ] ++ lib.teams.php.members;
  };
})

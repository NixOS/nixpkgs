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

  vendorHash = "sha256-SswaHYkDhuW2HZX7QiBd7K6wTmt42z2/TpB7HP68b7k=";

  meta = {
    changelog = "https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/tag/${finalAttrs.version}";
    description = "PHP coding standard tool";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/PHPCSStandards/PHP_CodeSniffer/";
    maintainers = with lib.maintainers; [ javaguirre ];
    teams = [ lib.teams.php ];
  };
})

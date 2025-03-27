{
  fetchFromGitHub,
  lib,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "php-codesniffer";
  version = "3.12.0";

  src = fetchFromGitHub {
    owner = "PHPCSStandards";
    repo = "PHP_CodeSniffer";
    tag = "${finalAttrs.version}";
    hash = "sha256-wlI/ylBeSkeg96sDwvDV9EedSLILFqsl96yWIOFtDQo=";
  };

  vendorHash = "sha256-RY/GOMK+Qq36du8GLXXiwjDjKD49gNN02OugwjOvrJ4=";

  meta = {
    changelog = "https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/tag/${finalAttrs.version}";
    description = "PHP coding standard tool";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/PHPCSStandards/PHP_CodeSniffer/";
    maintainers = with lib.maintainers; [ javaguirre ] ++ lib.teams.php.members;
  };
})

{
  fetchFromGitHub,
  lib,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "php-codesniffer";
  version = "3.13.1";

  src = fetchFromGitHub {
    owner = "PHPCSStandards";
    repo = "PHP_CodeSniffer";
    tag = finalAttrs.version;
    hash = "sha256-4znDEHFdDvshpa6BTyr+YV+IcSB486jTtnAk1fzPFt8=";
  };

  vendorHash = "sha256-j4SFRDf+JO3vnB7yo3wP9U00zjSPURr0fMuSvn4leAk=";

  meta = {
    changelog = "https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/tag/${finalAttrs.version}";
    description = "PHP coding standard tool";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/PHPCSStandards/PHP_CodeSniffer/";
    maintainers = with lib.maintainers; [ javaguirre ];
    teams = [ lib.teams.php ];
  };
})

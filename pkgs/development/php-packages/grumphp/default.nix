{
  fetchFromGitHub,
  lib,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "grumphp";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "phpro";
    repo = "grumphp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cgrQ8cBe6pQVofcJK1l2Vylt1SESwy0pvW7BIFS6uuM=";
  };

  vendorHash = "sha256-lzrPVkklU8NOhq4G2bJLLv8IxcSma6jx4hEvCr0ufuA=";

  meta = {
    changelog = "https://github.com/phpro/grumphp/releases/tag/v${finalAttrs.version}";
    description = "PHP code-quality tool";
    homepage = "https://github.com/phpro/grumphp";
    license = lib.licenses.mit;
    mainProgram = "grumphp";
    maintainers = lib.teams.php.members;
  };
})

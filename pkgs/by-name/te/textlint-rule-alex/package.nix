{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  textlint,
  textlint-rule-alex,
}:

buildNpmPackage rec {
  pname = "textlint-rule-alex";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "textlint-rule";
    repo = "textlint-rule-alex";
    tag = "v${version}";
    hash = "sha256-1JoiUhiRXZWIyLAJXp5ZzFAa/NBCN79jYh5kMNbO0jI=";
  };

  npmDepsHash = "sha256-ovDDiOZ415ubyDqbLNggzoVuqUWsRlG3zlhRW6xU3SQ=";

  passthru.tests = textlint.testPackages {
    rule = textlint-rule-alex;
    testFile = ./test.md;
  };

  meta = {
    description = "Textlint rule for alex";
    homepage = "https://github.com/textlint-rule/textlint-rule-alex";
    changelog = "https://github.com/textlint-rule/textlint-rule-alex/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}

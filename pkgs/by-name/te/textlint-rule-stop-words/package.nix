{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  textlint,
  textlint-rule-stop-words,
}:

buildNpmPackage rec {
  pname = "textlint-rule-stop-words";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "sapegin";
    repo = "textlint-rule-stop-words";
    tag = "v${version}";
    hash = "sha256-e9jTbDULOs0DwtT9UZp7k5+RR5Ab/x/sizIvs1MrmZs=";
  };

  npmDepsHash = "sha256-t9PPHFIiY4vw0ocw6nMuaeYuYWxbc1Pzo0R6bqIsHeI=";

  dontNpmBuild = true;

  passthru.tests = textlint.testPackages {
    rule = textlint-rule-stop-words;
    testFile = ./test.md;
  };

  meta = {
    description = "Textlint rule to find filler words, buzzwords and clichés";
    homepage = "https://github.com/sapegin/textlint-rule-stop-words";
    changelog = "https://github.com/sapegin/textlint-rule-stop-words/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}

{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  textlint,
  textlint-rule-terminology,
}:

buildNpmPackage rec {
  pname = "textlint-rule-terminology";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "sapegin";
    repo = "textlint-rule-terminology";
    rev = "refs/tags/v${version}";
    hash = "sha256-/NuKZSugizP4b2LFNqPrTvoXNE4D1sytU2B7T40ZASQ=";
  };

  npmDepsHash = "sha256-FQr7E6ZSJxj/ide+3JJwc27x15L1bAIAlPnMl8hdQ8w=";

  dontNpmBuild = true;

  passthru.tests = textlint.testPackages {
    rule = textlint-rule-terminology;
    testFile = ./test.md;
  };

  meta = {
    description = "Textlint rule to check correct terms spelling";
    homepage = "https://github.com/sapegin/textlint-rule-terminology";
    changelog = "https://github.com/sapegin/textlint-rule-terminology/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}

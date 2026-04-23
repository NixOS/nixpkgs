{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  textlint,
  textlint-rule-stop-words,
}:

buildNpmPackage (finalAttrs: {
  pname = "textlint-rule-stop-words";
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "sapegin";
    repo = "textlint-rule-stop-words";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QN3IptBxX/GTaySWQt43k6UDCKiG4Lp8MowHZ9EPRVQ=";
  };

  npmDepsHash = "sha256-UEiSMHZ8tvq/CoRA/wuV7bEZ6Njj3+cjoz139JH46Ks=";

  passthru.tests = textlint.testPackages {
    rule = textlint-rule-stop-words;
    testFile = ./test.md;
  };

  meta = {
    description = "Textlint rule to find filler words, buzzwords and clichés";
    homepage = "https://github.com/sapegin/textlint-rule-stop-words";
    changelog = "https://github.com/sapegin/textlint-rule-stop-words/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
})

{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  textlint,
  textlint-rule-stop-words,
}:

buildNpmPackage rec {
  pname = "textlint-rule-stop-words";
  version = "5.1.2";

  src = fetchFromGitHub {
    owner = "sapegin";
    repo = "textlint-rule-stop-words";
    tag = "v${version}";
    hash = "sha256-BCex7YeYiZSch8zjdL0chSng4ezisMcFm/T1J81q2h4=";
  };

  npmDepsHash = "sha256-GPR7zLpaTiBqG06ckMWnEsVuejVeAv9V9oV6ENRQDR8=";

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

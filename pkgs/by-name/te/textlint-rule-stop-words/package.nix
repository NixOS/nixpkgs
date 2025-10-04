{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  textlint,
  textlint-rule-stop-words,
}:

buildNpmPackage rec {
  pname = "textlint-rule-stop-words";
  version = "5.1.3";

  src = fetchFromGitHub {
    owner = "sapegin";
    repo = "textlint-rule-stop-words";
    tag = "v${version}";
    hash = "sha256-UE4IqdcDH0xDHh5WIff97u40q6Smpt6ATRIl03/1Nxs=";
  };

  npmDepsHash = "sha256-9l81nsgCIBGOQxcO+fguxcNpgg3NpYY3aarCH9FchGM=";

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

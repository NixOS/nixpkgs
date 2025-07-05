{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  textlint,
  textlint-rule-terminology,
}:

buildNpmPackage rec {
  pname = "textlint-rule-terminology";
  version = "5.2.13";

  src = fetchFromGitHub {
    owner = "sapegin";
    repo = "textlint-rule-terminology";
    tag = "v${version}";
    hash = "sha256-DLBHIsf0Oj+xHa8KcrXxn6wHYLHxu/w1k8CBNlGvymE=";
  };

  npmDepsHash = "sha256-ugyoQxfot5yfnLYAiPKh5/O7fL09YusynXe34bFj/bQ=";

  dontNpmBuild = true;

  passthru.tests = textlint.testPackages {
    rule = textlint-rule-terminology;
    testFile = ./test.md;
  };

  meta = {
    description = "Textlint rule to check correct terms spelling";
    homepage = "https://github.com/sapegin/textlint-rule-terminology";
    changelog = "https://github.com/sapegin/textlint-rule-terminology/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}

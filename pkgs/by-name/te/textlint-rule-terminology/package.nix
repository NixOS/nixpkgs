{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  textlint,
  textlint-rule-terminology,
}:

buildNpmPackage rec {
  pname = "textlint-rule-terminology";
  version = "5.2.15";

  src = fetchFromGitHub {
    owner = "sapegin";
    repo = "textlint-rule-terminology";
    tag = "v${version}";
    hash = "sha256-BIm7HVfoti0AjriotHvghjXbSDheUVWYutVH7ajlotg=";
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

{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  textlint,
  textlint-rule-terminology,
}:

buildNpmPackage (finalAttrs: {
  pname = "textlint-rule-terminology";
  version = "5.2.16";

  src = fetchFromGitHub {
    owner = "sapegin";
    repo = "textlint-rule-terminology";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XtyPOK2nrtlUQO6cx+ozVj27jvezCAKQ/+E0UDriCQw=";
  };

  npmDepsHash = "sha256-ZUM+zNl9kgEu0KHIVmnLDZ+1PJPE2e2wP6Hofe/9zPQ=";

  passthru.tests = textlint.testPackages {
    rule = textlint-rule-terminology;
    testFile = ./test.md;
  };

  meta = {
    description = "Textlint rule to check correct terms spelling";
    homepage = "https://github.com/sapegin/textlint-rule-terminology";
    changelog = "https://github.com/sapegin/textlint-rule-terminology/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
})

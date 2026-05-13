{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  textlint,
  textlint-plugin-latex2e,
  textlint-rule-max-comma,
}:

buildNpmPackage rec {
  pname = "textlint-plugin-latex2e";
  version = "1.2.1-unstable-2024-02-05";

  src = fetchFromGitHub {
    owner = "textlint";
    repo = "textlint-plugin-latex2e";
    rev = "d3ba1be14543aaaf8e52f87d103fafb3ebb7c4b0";
    hash = "sha256-sCDpyhnznMAkIPWK0BawWZwuR9UO/ipIG2o5hyBkJQ0=";
  };

  npmDepsHash = "sha256-u2cMZC3s4iGCWG6iVMDYfb6XbxfjCdwpzl7opkwtrU8=";

  passthru.tests = textlint.testPackages {
    inherit (textlint-plugin-latex2e) pname;
    rule = textlint-rule-max-comma;
    plugin = textlint-plugin-latex2e;
    testFile = ./test.tex;
  };

  meta = {
    description = "Textlint Plugin LaTeX2ε";
    homepage = "https://github.com/textlint/textlint-plugin-latex2e";
    changelog = "https://github.com/textlint/textlint-plugin-latex2e/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}

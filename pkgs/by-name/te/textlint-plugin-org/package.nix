{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  textlint,
  textlint-plugin-org,
  textlint-rule-max-comma,
}:

buildNpmPackage rec {
  pname = "textlint-plugin-org";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "kijimaD";
    repo = "textlint-plugin-org";
    rev = "refs/tags/v${version}";
    hash = "sha256-BW+b09nv9Mzl3cUcOOpHoRz8tGLxuGGo4UCY6kdUlXA=";
  };

  npmDepsHash = "sha256-J1ksstPED7FwB80N4CzfZ1i2xc3Wmu7s4T3acOrWA9s=";

  passthru.tests = textlint.testPackages {
    inherit (textlint-plugin-org) pname;
    rule = textlint-rule-max-comma;
    plugin = textlint-plugin-org;
    testFile = ./test.org;
  };

  meta = {
    description = "Org mode support for textlint";
    homepage = "https://github.com/kijimaD/textlint-plugin-org";
    changelog = "https://github.com/kijimaD/textlint-plugin-org/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}

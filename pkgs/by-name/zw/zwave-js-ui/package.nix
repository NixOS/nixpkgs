{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nixosTests,
}:

buildNpmPackage rec {
  pname = "zwave-js-ui";
  version = "9.31.0";

  src = fetchFromGitHub {
    owner = "zwave-js";
    repo = "zwave-js-ui";
    tag = "v${version}";
    hash = "sha256-KlJqzAgMyjA9OxCsKRICZ82ZBe+GpNuBvEHCtG5jvc4=";
  };
  npmDepsHash = "sha256-qy3hnZ9KvMRBJ+XVjxFdS8jQvlhvOEEZDcZUgQaFUT0=";

  passthru.tests.zwave-js-ui = nixosTests.zwave-js-ui;

  meta = {
    description = "Full featured Z-Wave Control Panel and MQTT Gateway";
    homepage = "https://zwave-js.github.io/zwave-js-ui/";
    license = lib.licenses.mit;
    downloadPage = "https://github.com/zwave-js/zwave-js-ui/releases";
    changelog = "https://github.com/zwave-js/zwave-js-ui/blob/v${version}/CHANGELOG.md";
    mainProgram = "zwave-js-ui";
    maintainers = with lib.maintainers; [ cdombroski ];
  };
}

{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nixosTests,
}:

buildNpmPackage rec {
  pname = "zwave-js-ui";
  version = "11.4.1";

  src = fetchFromGitHub {
    owner = "zwave-js";
    repo = "zwave-js-ui";
    tag = "v${version}";
    hash = "sha256-28FaP8T5TllbibUPJIQBgmnR8Bc4dXWyIS2AGSY0YtE=";
  };
  npmDepsHash = "sha256-OEewVf9CL17Koq2bFE0rOjPaBIgotSo8iHWl3Lp/chk=";

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

{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nixosTests,
}:

buildNpmPackage rec {
  pname = "zwave-js-ui";
  version = "9.17.0";

  src = fetchFromGitHub {
    owner = "zwave-js";
    repo = "zwave-js-ui";
    rev = "v${version}";
    hash = "sha256-GCBVRjDpiC8WhPHFwKnzyO5I09TDx3IbxpUZvwDu2u0=";
  };
  npmDepsHash = "sha256-YtHiBVz2eyHyJkr4K1NZXVZKdZTmdGMDFGpEC0QUCMU=";

  passthru.tests.zwave-js-ui = nixosTests.zwave-js-ui;

  meta = {
    description = "Full featured Z-Wave Control Panel and MQTT Gateway";
    homepage = "https://zwave-js.github.io/zwave-js-ui/";
    license = lib.licenses.mit;
    downloadPage = "https://github.com/zwave-js/zwave-js-ui/releases";
    changelog = "https://github.com/zwave-js/zwave-js-ui/blob/master/CHANGELOG.md";
    mainProgram = "zwave-js-ui";
    maintainers = with lib.maintainers; [ cdombroski ];
  };
}

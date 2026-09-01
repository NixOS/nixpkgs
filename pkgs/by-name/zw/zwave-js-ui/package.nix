{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nixosTests,
}:

buildNpmPackage rec {
  pname = "zwave-js-ui";
  version = "11.23.0";

  src = fetchFromGitHub {
    owner = "zwave-js";
    repo = "zwave-js-ui";
    tag = "v${version}";
    hash = "sha256-BDUutMwzbqdhpdDLpHMF1lfFAK2lE9fS1qnQJLZ9BMU=";
  };
  npmDepsHash = "sha256-9Cv26hEenftt1uRbag+3/UgLGDoidG8Jl6H+N67+a08=";

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

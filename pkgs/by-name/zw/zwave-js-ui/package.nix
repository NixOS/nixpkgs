{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nixosTests,
}:

buildNpmPackage rec {
  pname = "zwave-js-ui";
  version = "11.4.0";

  src = fetchFromGitHub {
    owner = "zwave-js";
    repo = "zwave-js-ui";
    tag = "v${version}";
    hash = "sha256-cuYYrMYP+kN7CPjKLG9BBp+3mx7gxqc+DgOpO9oCIzs=";
  };
  npmDepsHash = "sha256-LYooGYjifqPWo/wm8pVnIEC4AoEp0jiq/7w9CjR/yo0=";

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

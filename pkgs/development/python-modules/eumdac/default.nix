{
  lib,
  buildPythonPackage,
  certifi,
  fetchFromGitLab,
  nix-update-script,
  paho-mqtt,
  pytestCheckHook,
  pyyaml,
  requests,
  responses,
  setuptools,
  urllib3,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "eumdac";
  version = "3.1.1";
  pyproject = true;

  # PyPI sdist omits tests/base.py and tests/data fixtures.
  src = fetchFromGitLab {
    domain = "gitlab.eumetsat.int";
    group = "eumetlab";
    owner = "data-services";
    repo = pname;
    tag = version;
    hash = "sha256-756KYhlmQR/s7uRO5+m3XPIDbd8pEW3mE2szhYz/MxY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    certifi
    paho-mqtt
    pyyaml
    requests
    urllib3
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    export EUMDAC_CONFIG_DIR="$TMPDIR/.eumdac"
    mkdir -p "$EUMDAC_CONFIG_DIR/orders/active"

    # `from sh import eumdac` is an unused import that fails collection in nix.
    substituteInPlace tests/test_subscription.py \
      --replace-fail "from sh import eumdac" ""
  '';

  disabledTestPaths = [
    # Requires live EUMETSAT endpoints.
    "tests/test_other_functional.py"
  ];

  pythonImportsCheck = [ "eumdac" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "EUMETSAT Data Access Client";
    homepage = "https://gitlab.eumetsat.int/eumetlab/data-services/eumdac";
    changelog = "https://user.eumetsat.int/resources/user-guides/eumetsat-data-access-client-eumdac-release-changelog";
    license = lib.licenses.mit;
    mainProgram = "eumdac";
    maintainers = with lib.maintainers; [ Zaczero ];
  };
}

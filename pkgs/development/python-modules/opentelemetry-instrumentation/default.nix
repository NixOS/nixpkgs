{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  opentelemetry-api,
  opentelemetry-test-utils,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  wrapt,
}:

buildPythonPackage rec {
  pname = "opentelemetry-instrumentation";
  version = "0.55b0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  # To avoid breakage, every package in opentelemetry-python-contrib must inherit this version, src, and meta
  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python-contrib";
    tag = "v${version}";
    hash = "sha256-UM9ezCh3TVwyj257O0rvTCIgfrddobWcVIgJmBUj/Vo=";
  };

  sourceRoot = "${src.name}/opentelemetry-instrumentation";

  build-system = [ hatchling ];

  dependencies = [
    opentelemetry-api
    setuptools
    wrapt
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation" ];

  disabledTests = [
    # bootstrap: error: argument -a/--action: invalid choice: 'pipenv' (choose from install, requirements)
    # RuntimeError: Patch is already started
    "test_run_cmd_install"
    "test_run_cmd_print"
    "test_run_unknown_cmd"
  ];

  passthru.updateScript = opentelemetry-api.updateScript;

  meta = with lib; {
    description = "Instrumentation Tools & Auto Instrumentation for OpenTelemetry Python";
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/opentelemetry-instrumentation";
    changelog = "https://github.com/open-telemetry/opentelemetry-python-contrib/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.natsukium ];
    teams = [ teams.deshaw ];
  };
}

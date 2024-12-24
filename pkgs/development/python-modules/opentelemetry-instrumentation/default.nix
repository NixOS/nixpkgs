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
  version = "0.48b0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  # To avoid breakage, every package in opentelemetry-python-contrib must inherit this version, src, and meta
  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python-contrib";
    rev = "refs/tags/v${version}";
    hash = "sha256-RsOOCDbxT0e0WGfI8Ibv6E51ei+sTg07F8d+30+JrVU=";
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
    changelog = "https://github.com/open-telemetry/opentelemetry-python-contrib/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    license = licenses.asl20;
    maintainers = teams.deshaw.members ++ [ maintainers.natsukium ];
  };
}

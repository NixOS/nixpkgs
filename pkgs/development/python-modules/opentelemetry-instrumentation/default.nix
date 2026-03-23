{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  opentelemetry-api,
  opentelemetry-semantic-conventions,
  setuptools,
  wrapt,

  # tests
  opentelemetry-test-utils,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "opentelemetry-instrumentation";
  version = "0.61b0";
  pyproject = true;

  # To avoid breakage, every package in opentelemetry-python-contrib must inherit this version, src, and meta
  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python-contrib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UM9ezCh3TVwyj257O0rvTCIgfrddobWcVIgJmBUj/Vo=";
  };

  sourceRoot = "${finalAttrs.src.name}/opentelemetry-instrumentation";

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "opentelemetry-semantic-conventions"
  ];
  dependencies = [
    opentelemetry-api
    opentelemetry-semantic-conventions
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

  meta = {
    description = "Instrumentation Tools & Auto Instrumentation for OpenTelemetry Python";
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/opentelemetry-instrumentation";
    changelog = "https://github.com/open-telemetry/opentelemetry-python-contrib/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.natsukium ];
  };
})

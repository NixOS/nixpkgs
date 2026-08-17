{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  setuptools,

  # dependencies
  click,
  cloudevents,
  deprecation,
  flask,
  gunicorn,
  starlette,
  uvicorn,
  uvicorn-worker,
  watchdog,
  werkzeug,

  # tests
  docker,
  httpx,
  pretend,
  pytest-asyncio,
  pytestCheckHook,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "functions-framework";
  version = "3.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "functions-framework-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CEH0PokH3lhyJl7OPIpJkaKZxAUp1fYVia89DtGoJ7k=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "cloudevents"
  ];
  dependencies = [
    click
    cloudevents
    deprecation
    flask
    gunicorn
    starlette
    uvicorn
    uvicorn-worker
    watchdog
    werkzeug
  ];

  nativeCheckInputs = [
    docker
    httpx
    pretend
    pytest-asyncio
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [ "functions_framework" ];

  disabledTestPaths = lib.optionals (pythonAtLeast "3.14") [
    # _pickle.PicklingError: Can't pickle local object <function Flask.__init__.<locals>.<lambda> at 0x7ffff47e54e0>
    "tests/test_timeouts.py"
  ];

  disabledTests = [
    # Test requires a running Docker instance
    "test_cloud_run_http"
  ];

  meta = {
    description = "FaaS (Function as a service) framework for writing portable Python functions";
    homepage = "https://github.com/GoogleCloudPlatform/functions-framework-python";
    changelog = "https://github.com/GoogleCloudPlatform/functions-framework-python/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})

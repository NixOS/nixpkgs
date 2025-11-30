{
  lib,
  buildPythonPackage,
  click,
  cloudevents,
  deprecation,
  docker,
  fetchFromGitHub,
  flask,
  gunicorn,
  httpx,
  pretend,
  pytest-asyncio,
  pytestCheckHook,
  requests,
  setuptools,
  starlette,
  uvicorn,
  uvicorn-worker,
  watchdog,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "functions-framework";
  version = "3.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "functions-framework-python";
    tag = "v${version}";
    hash = "sha256-wH/6EOxdmEHq799MWcDyqdrgiurOHFFv7+cE9mWHhl0=";
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

  disabledTests = [
    # Test requires a running Docker instance
    "test_cloud_run_http"
  ];

  meta = {
    description = "FaaS (Function as a service) framework for writing portable Python functions";
    homepage = "https://github.com/GoogleCloudPlatform/functions-framework-python";
    changelog = "https://github.com/GoogleCloudPlatform/functions-framework-python/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}

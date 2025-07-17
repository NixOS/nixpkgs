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
  pretend,
  pytest-asyncio,
  pytestCheckHook,
  requests,
  setuptools,
  watchdog,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "functions-framework";
  version = "3.8.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "functions-framework-python";
    rev = "v${version}";
    hash = "sha256-kfoSGe08vCOXunzFH5FA7/NesOwAklfChKeoIfBXBlQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    cloudevents
    deprecation
    flask
    gunicorn
    watchdog
    werkzeug
  ];

  nativeCheckInputs = [
    docker
    pretend
    pytest-asyncio
    pytestCheckHook
    requests
  ];

  disabledTests = [
    # Test requires a running Docker instance
    "test_cloud_run_http"
  ];

  pythonImportsCheck = [ "functions_framework" ];

  meta = {
    description = "FaaS (Function as a service) framework for writing portable Python functions";
    homepage = "https://github.com/GoogleCloudPlatform/functions-framework-python";
    changelog = "https://github.com/GoogleCloudPlatform/functions-framework-python/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}

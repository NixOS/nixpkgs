{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  deprecation,
  flask,
  pydantic,
  pytestCheckHook,
  requests,
  sanic,
  sanic-testing,
}:

buildPythonPackage rec {
  pname = "cloudevents";
  version = "1.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cloudevents";
    repo = "sdk-python";
    tag = version;
    hash = "sha256-0WdCBwYz3XJWjUP0gf+IWdF4ZgPHFvUZFoQp9taqNz8=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "cloudevents" ];

  nativeCheckInputs = [
    deprecation
    flask
    pydantic
    pytestCheckHook
    requests
    sanic
    sanic-testing
  ];

  disabledTestPaths = [ "samples/http-image-cloudevents/image_sample_test.py" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Python SDK for CloudEvents";
    homepage = "https://github.com/cloudevents/sdk-python";
    changelog = "https://github.com/cloudevents/sdk-python/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}

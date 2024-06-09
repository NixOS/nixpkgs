{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
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
  version = "1.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cloudevents";
    repo = "sdk-python";
    rev = "refs/tags/${version}";
    hash = "sha256-YIvEAofWmnUblRd4jV3Zi3VdfocOnD05CMVm/abngyg=";
  };

  build-system = [
    setuptools
    wheel
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

  meta = with lib; {
    description = "Python SDK for CloudEvents";
    homepage = "https://github.com/cloudevents/sdk-python";
    changelog = "https://github.com/cloudevents/sdk-python/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}

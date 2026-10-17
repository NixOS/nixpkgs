{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  aiohttp,
  pytz,
  requests,
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov-stub,
  pydantic,
  responses,
}:

buildPythonPackage rec {
  pname = "fhirpy";
  version = "2.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beda-software";
    repo = "fhir-py";
    tag = "v${version}";
    hash = "sha256-thPUxsK0Nnvk4WGWQ4QuBmBrggL95G4G9Izx0oY8X8c=";
  };

  build-system = [ flit-core ];

  dependencies = [
    aiohttp
    pytz
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
    pydantic
    responses
  ];

  # sync/async test cases require docker-compose to set up services, so disable:
  disabledTestPaths = [ "tests/test_lib_sync.py" ];
  disabledTests = [ "TestLibAsyncCase" ];

  pythonImportsCheck = [ "fhirpy" ];

  meta = {
    description = "Async/sync API for FHIR resources";
    homepage = "https://github.com/beda-software/fhir-py";
    changelog = "https://github.com/beda-software/fhir-py/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}

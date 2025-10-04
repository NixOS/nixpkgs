{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
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
  pname = "fhir-py";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "beda-software";
    repo = "fhir-py";
    tag = "v${version}";
    hash = "sha256-ffaDWo/6xQwpMjiOCx3JIGtSHUjwcEilInD/YN73ZMI=";
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

  meta = with lib; {
    description = "Async/sync API for FHIR resources";
    homepage = "https://github.com/beda-software/fhir-py";
    changelog = "https://github.com/beda-software/fhir-py/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}

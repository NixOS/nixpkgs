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
  version = "2.0.11";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "beda-software";
    repo = "fhir-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-ts4BT/YVfejyemEy8B9aAJuA9h1a5F/SoIAkDVem7mQ=";
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
    changelog = "https://github.com/beda-software/fhir-py/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}

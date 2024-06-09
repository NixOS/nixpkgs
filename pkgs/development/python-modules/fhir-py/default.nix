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
  responses,
}:

buildPythonPackage rec {
  pname = "fhir-py";
  version = "1.4.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "beda-software";
    repo = "fhir-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-kYqoRso1ypN5novRxMMzz1h2NGNybbw5lK4+HErG79I=";
  };

  preBuild = ''
    substituteInPlace pyproject.toml  \
      --replace "--cov=fhirpy" ""  \
      --replace "--cov-report=xml" ""
  '';

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    aiohttp
    pytz
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
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

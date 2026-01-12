{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  aiohttp,
  aiohttp-retry,
  pydantic,
  pytest-aiohttp,
  pytestCheckHook,
  python-dateutil,
  typing-extensions,
  urllib3,
}:

buildPythonPackage rec {
  pname = "fitbit-web-api";
  version = "2.13.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "fitbit-web-api";
    tag = "v${version}";
    hash = "sha256-HqlySvC6EGnetrh0t8shapS/ggSRVoI8xPXta2eBqlk=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    aiohttp-retry
    pydantic
    python-dateutil
    typing-extensions
    urllib3
  ];

  pythonImportsCheck = [ "fitbit_web_api" ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/allenporter/fitbit-web-api/blob/${src.tag}/CHANGELOG.md";
    description = "Access data from Fitbit activity trackers, Aria scale, and manually entered logs";
    homepage = "https://github.com/allenporter/fitbit-web-api";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}

{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  ical,
  pydantic,
  pytest-aiohttp,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "gcal-sync";
  version = "6.2.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "gcal_sync";
    rev = "refs/tags/${version}";
    hash = "sha256-424PRKjQnpb6fH+iSAqkoOhlvugW7W3wjUxCHTc/A20=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    aiohttp
    ical
    pydantic
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    freezegun
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "gcal_sync" ];

  meta = with lib; {
    description = "Library for syncing Google Calendar to local storage";
    homepage = "https://github.com/allenporter/gcal_sync";
    changelog = "https://github.com/allenporter/gcal_sync/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}

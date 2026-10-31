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
  version = "9.2.0";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "gcal_sync";
    tag = version;
    hash = "sha256-/RnwykiqrYYWTyqHMeml/lSryjii5ji7y4donK3QmSs=";
  };

  build-system = [ setuptools ];

  dependencies = [
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

  meta = {
    description = "Library for syncing Google Calendar to local storage";
    homepage = "https://github.com/allenporter/gcal_sync";
    changelog = "https://github.com/allenporter/gcal_sync/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}

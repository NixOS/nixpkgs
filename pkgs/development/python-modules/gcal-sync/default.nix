{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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
  version = "7.0.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "gcal_sync";
    tag = version;
    hash = "sha256-8VUXW6tIX43TV7UIxeforZIxAUqGY9uqpz6WGyH4d8E=";
  };

  patches = [
    (fetchpatch {
      name = "ical-v9-compat.patch";
      url = "https://github.com/allenporter/gcal_sync/commit/7ce4b4214568764c234bff179cf05f7e03e21c1b.patch";
      hash = "sha256-OKFOl1uSCFECbZJe5/J+9oD3fpX/sRM1zPgJ+fmBqPg=";
      excludes = [ "requirements_dev.txt" ];
    })
  ];

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

  meta = with lib; {
    description = "Library for syncing Google Calendar to local storage";
    homepage = "https://github.com/allenporter/gcal_sync";
    changelog = "https://github.com/allenporter/gcal_sync/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}

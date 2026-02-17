{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  ical,
  mashumaro,
  orjson,
  poetry-core,
  poetry-dynamic-versioning,
  pyjwt,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  python-dateutil,
  syrupy,
  time-machine,
  tzlocal,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioautomower";
  version = "2.7.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Thomas55555";
    repo = "aioautomower";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O1z0dhVtKfIOr7TrXFiPElC11isD4aDDLmzc0+OX+B8=";
  };

  postPatch = ''
    # Upstream doesn't set a version
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
  '';

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    aiohttp
    ical
    mashumaro
    orjson
    pyjwt
    python-dateutil
    tzlocal
  ];

  nativeCheckInputs = [
    aioresponses
    freezegun
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    time-machine
    syrupy
  ];

  pythonImportsCheck = [ "aioautomower" ];

  disabledTests = [
    # Timezone mismatches
    "test_set_datetime"
    "test_message_event"
    "test_async_get_messages"
  ];

  meta = {
    description = "Module to communicate with the Automower Connect API";
    homepage = "https://github.com/Thomas55555/aioautomower";
    changelog = "https://github.com/Thomas55555/aioautomower/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})

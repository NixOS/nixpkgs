{
  lib,
  aiohttp,
  aiointercept,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  ical,
  mashumaro,
  orjson,
  hatchling,
  pyjwt,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  python-dateutil,
  pyprojectVersionPatchHook,
  syrupy,
  time-machine,
  tzlocal,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioautomower";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Thomas55555";
    repo = "aioautomower";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V3U8WC12t0+BD3HgSes88NtenUNXGMTdj1JMzMdwRZQ=";
  };

  build-system = [ hatchling ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

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
    aiointercept
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

{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  ical,
  mashumaro,
  poetry-core,
  poetry-dynamic-versioning,
  pyjwt,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  python-dateutil,
  syrupy,
  time-machine,
  tzlocal,
}:

buildPythonPackage rec {
  pname = "aioautomower";
  version = "2.2.2";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Thomas55555";
    repo = "aioautomower";
    tag = "v${version}";
    hash = "sha256-ds/wNPaZYQ8Tk/GyqYrWYL99oU73JWc/3KBsMULBass=";
  };

  postPatch = ''
    # Upstream doesn't set a version
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    aiohttp
    ical
    mashumaro
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
    # File is missing
    "test_standard_mower"
    # Call no found
    "test_post_commands"
    # Timezone mismatches
    "test_full_planner_event"
    "test_sinlge_planner_event"
    "test_set_datetime"
    "test_message_event"
    "test_async_get_messages"
  ];

  meta = with lib; {
    description = "Module to communicate with the Automower Connect API";
    homepage = "https://github.com/Thomas55555/aioautomower";
    changelog = "https://github.com/Thomas55555/aioautomower/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}

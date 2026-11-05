{
  lib,
  aiohttp,
  assertpy,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  hatchling,
  pycryptodome,
  pytest-asyncio,
  pytest-mockservers,
  pytest-resource-path,
  pytestCheckHook,
  pytz,
  time-machine,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioswitcher";
  version = "6.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TomerFi";
    repo = "aioswitcher";
    tag = finalAttrs.version;
    hash = "sha256-VFW2T5VUTraolk93QZMrHx6gRmkPjZzNM2EAcWifasM=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [ hatchling ];

  pythonRelaxDeps = [ "aiohttp" ];

  dependencies = [
    aiohttp
    pycryptodome
  ];

  preCheck = ''
    export TZ=Asia/Jerusalem
  '';

  nativeCheckInputs = [
    assertpy
    freezegun
    pytest-asyncio
    pytest-mockservers
    pytest-resource-path
    pytestCheckHook
    pytz
    time-machine
  ];

  disabledTests = [
    # AssertionError: Expected <14:00> to be equal to <17:00>, but was not.
    "test_schedule_parser_with_a_weekly_recurring_enabled_schedule_data"
    "test_schedule_parser_with_a_daily_recurring_enabled_schedule_data"
    "test_schedule_parser_with_a_partial_daily_recurring_enabled_schedule_data"
    "test_schedule_parser_with_a_non_recurring_enabled_schedule_data"
  ];

  pythonImportsCheck = [ "aioswitcher" ];

  meta = {
    description = "Python module to interact with Switcher water heater";
    homepage = "https://github.com/TomerFi/aioswitcher";
    changelog = "https://github.com/TomerFi/aioswitcher/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})

{
  lib,
  aiohttp,
  assertpy,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  poetry-core,
  pycryptodome,
  pytest-asyncio,
  pytest-mockservers,
  pytest-resource-path,
  pytestCheckHook,
  pythonAtLeast,
  pytz,
  time-machine,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioswitcher";
  version = "6.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TomerFi";
    repo = "aioswitcher";
    tag = finalAttrs.version;
    hash = "sha256-SCJV2r6VB1Y1ceywHkoYDsO+PRnjualGdetnQrlBKDI=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [ poetry-core ];

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
  ]
  ++ lib.optionals (pythonAtLeast "3.12") [
    # AssertionError: Expected <'I' format requires 0 <= number <= 4294967295> to be equal to <argument out of range>, but was not.
    "test_minutes_to_hexadecimal_seconds_with_a_negative_value_should_throw_an_error"
    "test_current_timestamp_to_hexadecimal_with_errornous_value_should_throw_an_error"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # AssertionError: Expected <hour must be in 0..23, not -1> to be equal
    "test_seconds_to_iso_time_with_a_nagative_value_should_throw_an_error"
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

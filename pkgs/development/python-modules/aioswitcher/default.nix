{
  lib,
  assertpy,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  poetry-core,
  pycryptodome,
  pytest-asyncio,
  pytest-mockservers,
  pytest-resource-path,
  pytest-sugar,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  requests,
  time-machine,
  types-requests,
}:

buildPythonPackage rec {
  pname = "aioswitcher";
  version = "4.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "TomerFi";
    repo = "aioswitcher";
    rev = "refs/tags/${version}";
    hash = "sha256-a6Sl36X+r6mVqRAcO0C2f4CT/FDPF7r3VHnQp3328qo=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [ poetry-core ];

  dependencies = [
    pycryptodome
    requests
    types-requests
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
    pytest-sugar
    pytestCheckHook
    time-machine
  ];

  disabledTests =
    [
      # AssertionError: Expected <14:00> to be equal to <17:00>, but was not.
      "test_schedule_parser_with_a_weekly_recurring_enabled_schedule_data"
      "test_schedule_parser_with_a_daily_recurring_enabled_schedule_data"
      "test_schedule_parser_with_a_partial_daily_recurring_enabled_schedule_data"
      "test_schedule_parser_with_a_non_recurring_enabled_schedule_data"
    ]
    ++ lib.optionals (pythonAtLeast "3.12") [
      # ssertionError: Expected <'I' format requires 0 <= number <= 4294967295> to be equal to <argument out of range>, but was not.
      "test_minutes_to_hexadecimal_seconds_with_a_negative_value_should_throw_an_error"
      "test_current_timestamp_to_hexadecimal_with_errornous_value_should_throw_an_error"
    ];

  pythonImportsCheck = [ "aioswitcher" ];

  meta = with lib; {
    description = "Python module to interact with Switcher water heater";
    homepage = "https://github.com/TomerFi/aioswitcher";
    changelog = "https://github.com/TomerFi/aioswitcher/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

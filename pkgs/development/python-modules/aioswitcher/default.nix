{
  lib,
  assertpy,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-mockservers,
  pytest-resource-path,
  pytest-sugar,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  time-machine,
}:

buildPythonPackage rec {
  pname = "aioswitcher";
  version = "3.4.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "TomerFi";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-yKHSExtnO9m8Tc3BmCqV8tJs59ynKOqUmekaOatGRTc=";
  };

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [ poetry-core ];

  preCheck = ''
    export TZ=Asia/Jerusalem
  '';

  nativeCheckInputs = [
    assertpy
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

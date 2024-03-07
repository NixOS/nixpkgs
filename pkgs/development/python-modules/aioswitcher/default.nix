{ lib
, assertpy
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytest-mockservers
, pytest-resource-path
, pytest-sugar
, pytestCheckHook
, pythonOlder
, time-machine
}:

buildPythonPackage rec {
  pname = "aioswitcher";
  version = "3.4.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "TomerFi";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-UpwIzwOl1yKqK8KxFDXAWoZFkQ+1r1sUcDfx6AxRdNw=";
  };

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    poetry-core
  ];

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

  disabledTests = [
    # AssertionError: Expected <14:00> to be equal to <17:00>, but was not.
    "test_schedule_parser_with_a_weekly_recurring_enabled_schedule_data"
    "test_schedule_parser_with_a_daily_recurring_enabled_schedule_data"
    "test_schedule_parser_with_a_partial_daily_recurring_enabled_schedule_data"
    "test_schedule_parser_with_a_non_recurring_enabled_schedule_data"
  ];

  pythonImportsCheck = [
    "aioswitcher"
  ];

  meta = with lib; {
    description = "Python module to interact with Switcher water heater";
    homepage = "https://github.com/TomerFi/aioswitcher";
    changelog = "https://github.com/TomerFi/aioswitcher/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

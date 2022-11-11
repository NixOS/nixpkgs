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
  version = "3.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "TomerFi";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-Vob5p0+SlZR2eHj5Br2pWp3FCxW+zgY6crh8jrkreT0=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  preCheck = ''
    export TZ=Asia/Jerusalem
  '';

  checkInputs = [
    assertpy
    pytest-asyncio
    pytest-mockservers
    pytest-resource-path
    pytest-sugar
    pytestCheckHook
    time-machine
  ];

  pytestFlagsArray = [
    "--asyncio-mode=legacy"
  ];

  disabledTests = [
    # AssertionError: Expected <14:00> to be equal to <17:00>, but was not.
    "test_schedule_parser_with_a_weekly_recurring_enabled_schedule_data"
    "test_schedule_parser_with_a_daily_recurring_enabled_schedule_data"
    "test_schedule_parser_with_a_partial_daily_recurring_enabled_schedule_data"
    "test_schedule_parser_with_a_non_recurring_enabled_schedule_data"
    "test_hexadecimale_timestamp_to_localtime_with_the_current_timestamp_should_return_a_time_string"
  ];

  pythonImportsCheck = [
    "aioswitcher"
  ];

  meta = with lib; {
    description = "Python module to interact with Switcher water heater";
    homepage = "https://github.com/TomerFi/aioswitcher";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

{ lib
, aiohttp
, asynctest
, assertpy
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-aiohttp
, pytest-asyncio
, pytest-mockservers
, pytest-sugar
, pytest-resource-path
, pytestCheckHook
, time-machine
}:

buildPythonPackage rec {
  pname = "aioswitcher";
  version = "2.0.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "TomerFi";
    repo = pname;
    rev = version;
    sha256 = "1jv6asjbpshrqaazfhdpnx1maanam9pcccqh4whzpnvc52snz0lz";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    asynctest
    assertpy
    pytest-aiohttp
    pytest-asyncio
    pytest-mockservers
    pytest-sugar
    pytest-resource-path
    pytestCheckHook
    time-machine
  ];

  disabledTests = [
    # AssertionError: Expected <14:30>...
    "test_schedule_parser_with_a_weekly_recurring_enabled_schedule_data"
    "test_schedule_parser_with_a_daily_recurring_enabled_schedule_data"
    "test_schedule_parser_with_a_partial_daily_recurring_enabled_schedule_data"
    "test_schedule_parser_with_a_non_recurring_enabled_schedule_data"
  ];

  pythonImportsCheck = [ "aioswitcher" ];

  meta = with lib; {
    description = "Python module to interact with Switcher water heater";
    homepage = "https://github.com/TomerFi/aioswitcher";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

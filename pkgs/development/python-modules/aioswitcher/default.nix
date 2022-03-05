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
, time-machine
}:

buildPythonPackage rec {
  pname = "aioswitcher";
  version = "2.0.8";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "TomerFi";
    repo = pname;
    rev = version;
    sha256 = "sha256-4+XGSaHZNYjId0bTOwCkYpb1K/pM8WtN5/NI+GVaI7M=";
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

  disabledTests = [
    # AssertionError: Expected <14:00> to be equal to <17:00>, but was not.
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

{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, freezegun
, poetry-core
, pyjwt
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pytz
, titlecase
, types-pytz
}:

buildPythonPackage rec {
  pname = "aioridwell";
  version = "2022.03.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    hash = "sha256-UiHT1YbBb9UTughVw2oJxRtvhUDVqQWqEcXMEXwy2cI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    pyjwt
    pytz
    titlecase
  ];

  checkInputs = [
    aresponses
    freezegun
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
    types-pytz
  ];

  disabledTests = [
    # AssertionError: assert datetime.date(...
    "test_get_next_pickup_event"
  ];

  disabledTestPaths = [
    # Ignore the examples directory as the files are prefixed with test_
    "examples/"
  ];

  pythonImportsCheck = [
    "aioridwell"
  ];

  meta = with lib; {
    description = "Python library for interacting with Ridwell waste recycling";
    homepage = "https://github.com/bachya/aioridwell";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

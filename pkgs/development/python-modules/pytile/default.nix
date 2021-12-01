{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pylint
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytile";
  version = "2021.10.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "sha256-9FbcGhRmXULJgfJOmy6mhiZwQUDNmvxZI/WxjJIbnc8=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    pylint
  ];

  checkInputs = [
    aresponses
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Ignore the examples as they are prefixed with test_
    "examples/"
  ];

  pythonImportsCheck = [
    "pytile"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = " Python API for Tile Bluetooth trackers";
    longDescription = ''
      pytile is a simple Python library for retrieving information on Tile
      Bluetooth trackers (including last location and more).
    '';
    homepage = "https://github.com/bachya/pytile";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

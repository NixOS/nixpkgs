{ lib
, aiohttp
, async-timeout
, aresponses
, buildPythonPackage
, fetchFromGitHub
, poetry
, pylint
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonAtLeast
}:
buildPythonPackage rec {
  pname = "pytile";
  version = "5.1.0";
  disabled = pythonAtLeast "3.9";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "0hdyb8ca4ihqf7yfkr3hbpkwz7g182ycra151y5dxn0319fillc3";
  };

  format = "pyproject";

  nativeBuildInputs = [ poetry ];

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

  # Ignore the examples as they are prefixed with test_
  pytestFlagsArray = [ "--ignore examples/" ];
  pythonImportsCheck = [ "pytile" ];

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

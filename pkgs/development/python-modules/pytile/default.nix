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
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "pytile";
  version = "5.1.1";
  disabled = pythonAtLeast "3.9";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "sha256-bVoFTaK/Alemtc5I+Z/M9y/FWczvJ+P86R0DMD89/BM=";
  };

  format = "pyproject";

  nativeBuildInputs = [ poetry-core ];

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

{ lib
, aiohttp
, aresponses
, asynctest
, buildPythonPackage
, fetchFromGitHub
, numpy
, poetry-core
, pysmb
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyairvisual";
  version = "2022.07.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "sha256-UzcKK0LJ/Xp5iVWsrDQ3nfhWgKAAxKmXrK1zPSoG/gY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    numpy
    pysmb
  ];

  checkInputs = [
    aresponses
    asynctest
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Ignore the examples directory as the files are prefixed with test_.
    "examples/"
  ];

  pythonImportsCheck = [
    "pyairvisual"
  ];

  meta = with lib; {
    description = "Python library for interacting with AirVisual";
    homepage = "https://github.com/bachya/pyairvisual";
    changelog = "https://github.com/bachya/pyairvisual/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

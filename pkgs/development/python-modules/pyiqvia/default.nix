{ lib
, buildPythonPackage
, aiohttp
, aresponses
, backoff
, fetchFromGitHub
, poetry-core
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyiqvia";
  version = "2022.04.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    hash = "sha256-qW1rjKc1+w2rTUGackPjb0qgTZpFXh0ZRBqMmf4nDnk=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    backoff
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
    "pyiqvia"
  ];

  meta = with lib; {
    description = "Module for working with IQVIA data";
    longDescription = ''
      pyiqvia is an async-focused Python library for allergen, asthma, and
      disease data from the IQVIA family of websites (such as https://pollen.com,
      https://flustar.com and more).
    '';
    homepage = "https://github.com/bachya/pyiqvia";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

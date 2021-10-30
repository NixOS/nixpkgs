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
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "sha256-uDcBpPHh+wQHI2vGjnumwVGt5ZOreVq+L3kOam97uW4=";
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

  # Ignore the examples as they are prefixed with test_
  disabledTestPaths = [ "examples/" ];

  pythonImportsCheck = [ "pyiqvia" ];

  meta = with lib; {
    description = "Python3 API for IQVIA data";
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

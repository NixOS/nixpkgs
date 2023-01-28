{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "rki-covid-parser";
  version = "1.3.3";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "thebino";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-e0MJjE4zgBPL+vt9EkgsdGrgqUyKK/1S9ZFxy56PUjc=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-aiohttp
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Tests require netowrk access
    "tests/test_districts.py"
    "tests/test_endpoint_availibility.py"
  ];

  pythonImportsCheck = [
    "rki_covid_parser"
  ];

  meta = with lib; {
    description = "Python module for working with data from the Robert-Koch Institut";
    homepage = "https://github.com/thebino/rki-covid-parser";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}

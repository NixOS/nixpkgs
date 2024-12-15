{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rki-covid-parser";
  version = "1.3.3";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "thebino";
    repo = "rki-covid-parser";
    rev = "refs/tags/v${version}";
    hash = "sha256-e0MJjE4zgBPL+vt9EkgsdGrgqUyKK/1S9ZFxy56PUjc=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ aiohttp ];

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

  pythonImportsCheck = [ "rki_covid_parser" ];

  meta = with lib; {
    description = "Python module for working with data from the Robert-Koch Institut";
    homepage = "https://github.com/thebino/rki-covid-parser";
    changelog = "https://github.com/thebino/rki-covid-parser/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}

{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, lxml
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pytrafikverket";
  version = "0.3.9.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NxxuyLnzJ8T2jaQ761O943rpBbNwp/F4PygyQULkXzw=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    lxml
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pytrafikverket"
  ];

  meta = with lib; {
    description = "Library to get data from the Swedish Transport Administration (Trafikverket) API";
    homepage = "https://github.com/endor-force/pytrafikverket";
    changelog = "https://github.com/endor-force/pytrafikverket/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, async-timeout
, lxml
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytrafikverket";
  version = "0.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NWQHrdTKb3RQ7ZjXpHyQ5qPPXuZUU7G+FvBx1VQEbss=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
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

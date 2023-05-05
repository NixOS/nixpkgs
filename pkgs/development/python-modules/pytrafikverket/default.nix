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
  version = "0.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-foTIzWk/Y1H6OK+OAIU5VPlb/+gevc8WP9TzpYtnWvM=";
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

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
  version = "0.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LBOq1AvJrRmyWIe2w4dQbWvlRAJN6s2/lsJRI2LZK2o=";
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

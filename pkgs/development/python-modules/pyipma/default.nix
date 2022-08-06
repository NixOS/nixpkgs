{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, geopy
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyipma";
  version = "3.0.0";
  disabled = pythonOlder "3.7";

  # Request for GitHub releases, https://github.com/dgomes/pyipma/issues/10
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-LfnatA8CimHIXH3f3T4PatDBIEhh6vlQtI080iu8UEg=";
  };

  propagatedBuildInputs = [
    aiohttp
    geopy
  ];

  # Project has no tests included in the PyPI releases
  doCheck = false;

  pythonImportsCheck = [ "pyipma" ];

  meta = with lib; {
    description = "Python library to retrieve information from Instituto Português do Mar e Atmosfera";
    homepage = "https://github.com/dgomes/pyipma";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

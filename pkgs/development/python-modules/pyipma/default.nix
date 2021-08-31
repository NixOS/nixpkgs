{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, geopy
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyipma";
  version = "2.1.5";
  disabled = pythonOlder "3.7";

  # Request for GitHub releases, https://github.com/dgomes/pyipma/issues/10
  src = fetchPypi {
    inherit pname version;
    sha256 = "0hq5dasqpsn64x2sf6a28hdmysygmcdq4in6s08w97jfvwc6xmym";
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

{ lib
, aiohttp
, attrs
, buildPythonPackage
, fetchPypi
, jmespath
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysma";
  version = "0.7.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8LwxRiYUhKYZkrjDNcnOkssvfw/tZ6dj1GKZQ6UkqsQ=";
  };

  propagatedBuildInputs = [
    aiohttp
    attrs
    jmespath
  ];

  # pypi does not contain tests and GitHub archive not available
  doCheck = false;

  pythonImportsCheck = [
    "pysma"
  ];

  meta = with lib; {
    description = "Python library for interacting with SMA Solar's WebConnect";
    homepage = "https://github.com/kellerza/pysma";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

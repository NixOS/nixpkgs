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
  version = "0.6.10";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "990abf6dba3f52b98970fc95aaf484e521faa9ff28c9c19f5a6dca3fddf5840c";
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

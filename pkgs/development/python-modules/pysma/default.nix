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
  version = "0.7.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hIrdT0b9XKw1UoPZtQQ7IaW+HV8wuA9Rwoo8XYdGyw8=";
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

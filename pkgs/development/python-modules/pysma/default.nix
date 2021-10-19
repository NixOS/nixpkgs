{ lib
, aiohttp
, attrs
, buildPythonPackage
, fetchPypi
, jmespath
, async-timeout
}:

buildPythonPackage rec {
  pname = "pysma";
  version = "0.6.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8HADY6+qwfzYyEVLQyMiXiUYinADSA1iKUay3YHhNXI=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    attrs
    jmespath
  ];

  # pypi does not contain tests and GitHub archive not available
  doCheck = false;
  pythonImportsCheck = [ "pysma" ];

  meta = with lib; {
    description = "Python library for interacting with SMA Solar's WebConnect";
    homepage = "https://github.com/kellerza/pysma";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

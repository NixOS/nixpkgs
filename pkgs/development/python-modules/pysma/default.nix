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
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "da4bed38aba52fa097694bda15c7fd80ca698d9352e71a63bc29092d635de54d";
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

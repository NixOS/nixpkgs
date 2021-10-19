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
    sha256 = "f0700363afaac1fcd8c8454b4323225e25188a7003480d622946b2dd81e13572";
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

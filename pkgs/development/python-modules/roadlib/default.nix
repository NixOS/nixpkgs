{
  lib,
  aiohttp,
  cryptography,
  buildPythonPackage,
  fetchPypi,
  pyjwt,
  setuptools,
  requests,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "roadlib";
  version = "1.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RI6gUqCaOeLesIwHtsASEkTtdRxLCAP6+C5Yj8mBb2o=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    pyjwt
    requests
    sqlalchemy
  ];

  optional-dependencies = {
    async = [ aiohttp ];
  };

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [ "roadtools.roadlib" ];

  meta = with lib; {
    description = "ROADtools common components library";
    homepage = "https://pypi.org/project/roadlib/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

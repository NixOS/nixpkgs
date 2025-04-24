{
  lib,
  adal,
  buildPythonPackage,
  fetchPypi,
  pyjwt,
  pythonOlder,
  setuptools,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "roadlib";
  version = "0.29.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bCdPL9ic1zf6Kzv10bUQI5baqWofGDWk4ipuarsqbeY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    adal
    pyjwt
    sqlalchemy
  ];

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

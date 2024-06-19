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
  version = "0.24.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tQbJWHXxvjGhqGBI9nn8EL7rJcVyH095FfNSsxkrImQ=";
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

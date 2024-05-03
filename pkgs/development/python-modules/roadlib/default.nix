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
  version = "0.24.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+5vR2iTFu50PJIsj4sW6McH1sg3yyEIwk15W8Jk0GKA=";
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

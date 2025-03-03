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
  version = "0.29.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-147ej4qRH0pR5jeWd0+RjL8SgMu/eVRw9yFx1qJmy/Q=";
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

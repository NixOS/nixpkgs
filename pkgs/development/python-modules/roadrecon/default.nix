{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  flask,
  flask-cors,
  flask-marshmallow,
  flask-sqlalchemy,
  marshmallow,
  marshmallow-sqlalchemy,
  openpyxl,
  roadlib,
  setuptools,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "roadrecon";
  version = "1.7.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v8IUnJlREtKMnhJtdKtChcxM/IKNKRuHA79V38zxLGY=";
  };

  pythonRelaxDeps = [ "flask" ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    flask
    flask-cors
    flask-marshmallow
    flask-sqlalchemy
    marshmallow
    marshmallow-sqlalchemy
    openpyxl
    roadlib
    sqlalchemy
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "roadtools.roadrecon" ];

  meta = with lib; {
    description = "Azure AD recon";
    homepage = "https://pypi.org/project/roadrecon/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

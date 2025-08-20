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
  pythonOlder,
  roadlib,
  setuptools,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "roadrecon";
  version = "1.6.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0Rv88lbqvTJD183nLhvi2Ue1ZD1eoRW1sytJ+t85bcg=";
  };

  pythonRelaxDeps = [ "flask" ];

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
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

  pythonImportsCheck = [ "roadtools.roadrecon" ];

  meta = with lib; {
    description = "Azure AD recon";
    homepage = "https://pypi.org/project/roadrecon/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

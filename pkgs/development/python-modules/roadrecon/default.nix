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
  pythonRelaxDepsHook,
  roadlib,
  setuptools,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "roadrecon";
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OEftVwU30tLP091Z5CIl67hkjjcqY+Qo04/wHZlbuFc=";
  };

  pythonRelaxDeps = [ "flask" ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
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

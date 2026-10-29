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

buildPythonPackage (finalAttrs: {
  pname = "roadrecon";
  version = "1.7.4";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-V/McstT+2LAlNe4HHQ0xNfAIM0ExFstyEL3qQrEfkoQ=";
  };

  pythonRelaxDeps = [
    "marshmallow"
    "flask"
  ];

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

  meta = {
    description = "Azure AD recon";
    homepage = "https://pypi.org/project/roadrecon/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})

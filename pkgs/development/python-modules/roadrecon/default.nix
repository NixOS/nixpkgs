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
  version = "1.7.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-k800N0IN3I6liqgVbsgyywkg013/8GNWsShDPkK214w=";
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

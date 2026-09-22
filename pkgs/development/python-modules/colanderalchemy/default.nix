{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  colander,
  sqlalchemy,
}:

buildPythonPackage (finalAttrs: {
  pname = "colanderalchemy";
  version = "0.3.4";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "ColanderAlchemy";
    hash = "sha256-dA1DXmqXxIPjzgGWo24C41vpmwF04JVU3XxqAZlj3AA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colander
    sqlalchemy
  ];

  # Tests are not included in Pypi
  doCheck = false;

  pythonImportsCheck = [ "colanderalchemy" ];

  meta = {
    description = "Autogenerate Colander schemas based on SQLAlchemy models";
    homepage = "https://github.com/stefanofontanelli/ColanderAlchemy";
    license = lib.licenses.mit;
  };
})

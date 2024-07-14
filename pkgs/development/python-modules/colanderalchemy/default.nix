{
  lib,
  buildPythonPackage,
  fetchPypi,
  colander,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "colanderclchemy";
  version = "0.3.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dA1DXmqXxIPjzgGWo24C41vpmwF04JVU3XxqAZlj3AA=";
  };

  propagatedBuildInputs = [
    colander
    sqlalchemy
  ];

  # Tests are not included in Pypi
  doCheck = false;

  meta = with lib; {
    description = "Autogenerate Colander schemas based on SQLAlchemy models";
    homepage = "https://github.com/stefanofontanelli/ColanderAlchemy";
    license = licenses.mit;
  };
}

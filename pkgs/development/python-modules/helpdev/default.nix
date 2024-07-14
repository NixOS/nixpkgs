{
  lib,
  buildPythonPackage,
  fetchPypi,
  importlib-metadata,
  psutil,
}:

buildPythonPackage rec {
  pname = "helpdev";
  version = "0.7.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-u2KnmsusFB2t9Cyt65K7dFDdGLmCSmIEO2oLFJGQ2z0=";
  };

  propagatedBuildInputs = [
    importlib-metadata
    psutil
  ];

  # No tests included in archive
  doCheck = false;

  meta = {
    description = "Extracts information about the Python environment easily";
    mainProgram = "helpdev";
    license = lib.licenses.mit;
  };
}

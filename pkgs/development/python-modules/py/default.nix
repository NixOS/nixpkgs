{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "py";
  version = "1.11.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UcdcQSYHS0cvdGokOZrTL2BT0bNLaNL6QeVY5vSphxk=";
  };

  # Circular dependency on pytest
  doCheck = false;

  nativeBuildInputs = [ setuptools-scm ];

  pythonImportsCheck = [ "py" ];

  meta = with lib; {
    description = "Library with cross-python path, ini-parsing, io, code, log facilities";
    homepage = "https://py.readthedocs.io/";
    license = licenses.mit;
  };
}

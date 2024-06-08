{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "process-tests";
  version = "3.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5dV96nFhJR6RytuEvz7MhSdfsSH9R45Xn4AHd7HUJL0=";
  };

  nativeBuildInputs = [ setuptools ];

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Tools for testing processes";
    license = licenses.bsd2;
    homepage = "https://github.com/ionelmc/python-process-tests";
  };
}

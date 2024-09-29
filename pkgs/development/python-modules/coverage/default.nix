{
  lib,
  buildPythonPackage,
  fetchPypi,
  mock,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "coverage";
  version = "7.6.1";
  pyproject = true;

  # uses f strings
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lTUQ37exKradIBNaBmI5fwd8WbHmN5p2jpfFnYUu5R0=";
  };

  nativeBuildInputs = [ setuptools ];

  # No tests in archive
  doCheck = false;
  nativeCheckInputs = [ mock ];

  meta = {
    description = "Code coverage measurement for python";
    homepage = "https://coverage.readthedocs.io/";
    license = lib.licenses.bsd3;
  };
}

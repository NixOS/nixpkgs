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
  version = "7.8.0";
  pyproject = true;

  # uses f strings
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ej1is7A7S2/UGghfNXSHTPlGy0YE0rTT6NyozVcMpQE=";
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

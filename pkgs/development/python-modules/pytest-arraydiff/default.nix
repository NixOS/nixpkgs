{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  pytest,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-arraydiff";
  version = "0.7.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "pytest_arraydiff";
    inherit (finalAttrs) version;
    hash = "sha256-cOKpGDr1tPBfaUcnvrMOtfxnEmMrJA7yWexgmEpimxo=";
  };

  build-system = [ setuptools-scm ];

  buildInputs = [ pytest ];

  dependencies = [ numpy ];

  # The tests requires astropy, which itself requires pytest-arraydiff
  doCheck = false;

  pythonImportsCheck = [ "pytest_arraydiff" ];

  meta = {
    description = "Pytest plugin to help with comparing array output from tests";
    homepage = "https://github.com/astrofrog/pytest-arraydiff";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})

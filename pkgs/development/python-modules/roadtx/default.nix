{
  lib,
  buildPythonPackage,
  fetchPypi,
  pycryptodomex,
  pyotp,
  requests,
  roadlib,
  selenium,
  selenium-wire-roadtx,
  setuptools,
  signxml,
}:

buildPythonPackage (finalAttrs: {
  pname = "roadtx";
  version = "1.22.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-2GIJAjLxOqy3E+5j1gnby8F5IAvdnChMT4Lfq5I5zeE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pycryptodomex
    pyotp
    requests
    roadlib
    selenium
    selenium-wire-roadtx
    signxml
  ];

  pythonImportsCheck = [ "roadtools.roadtx" ];

  meta = {
    description = "ROADtools Token eXchange";
    homepage = "https://pypi.org/project/roadtx/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})

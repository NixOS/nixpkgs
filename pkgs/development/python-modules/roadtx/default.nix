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
  version = "1.22.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-kOsXowM5LM5jX8XW+G8u65P9y2/6ZMIwMFvbAtO/b34=";
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

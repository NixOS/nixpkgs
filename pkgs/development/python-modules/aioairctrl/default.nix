{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  aiocoap,
  pycryptodomex,
}:

buildPythonPackage rec {
  pname = "aioairctrl";
  version = "0.2.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BPUV79S2A0F6vZA2pd3XNLpmRHTp6RSoNXPcI+OJRbk=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    aiocoap
    pycryptodomex
  ];

  pythonImportsCheck = [ "aioairctrl" ];

  doCheck = false; # no tests

  meta = {
    description = "Library for controlling Philips air purifiers (using encrypted CoAP)";
    homepage = "https://github.com/kongo09/aioairctrl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ justinas ];
  };
}

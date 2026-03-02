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
  version = "0.2.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mQNgkgQ83GOSc0g0ATctlr4ZeB7g8iGd4qTZfyoO8DM=";
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

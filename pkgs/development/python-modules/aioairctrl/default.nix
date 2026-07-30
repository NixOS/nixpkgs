{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  aiocoap,
  pycryptodomex,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aioairctrl";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kongo09";
    repo = "aioairctrl";
    tag = "v${version}";
    hash = "sha256-Ea5OMbpwDubhnpY5K0CVXZneEGtNWkqkQQ7JwVa/JNU=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aiocoap
    pycryptodomex
  ];

  pythonImportsCheck = [ "aioairctrl" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/kongo09/aioairctrl/releases/tag/${src.tag}";
    description = "Library for controlling Philips air purifiers (using encrypted CoAP)";
    homepage = "https://github.com/kongo09/aioairctrl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ justinas ];
  };
}

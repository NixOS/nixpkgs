{
  lib,
  buildPythonPackage,
  fetchPypi,
  cryptography,
  deprecated,
  pytestCheckHook,
  hatchling,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "jwcrypto";
  version = "1.6.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-oeFXDaXC412803XsHSiRok3o6zXuLB/o6Rl477cs/pA=";
  };

  build-system = [ hatchling ];

  dependencies = [
    cryptography
    deprecated
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "jwcrypto" ];

  meta = {
    description = "Implementation of JOSE Web standards";
    homepage = "https://github.com/latchset/jwcrypto";
    changelog = "https://github.com/latchset/jwcrypto/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
  };
})

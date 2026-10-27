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
  version = "1.5.8";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-w9cRS29uZbUva32oF+uMuEI+HaMeHvE1CER8gey9zDQ=";
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
    changelog = "https://github.com/latchset/jwcrypto/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
  };
})

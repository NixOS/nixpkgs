{
  buildPythonPackage,
  fetchPypi,
  lib,

  # pythonPackages
  pyasn1-modules,
  pycryptodomex,
  setuptools,
  twofish,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyjks";
  version = "20.0.0";

  __structuredAttrs = true;
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-A3jOwV+xGy7Se6VNrZ/Zh9SOb2L0n8/xOPX3qLMSsEQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyasn1-modules
    pycryptodomex
    twofish
  ];

  # Tests assume network connectivity
  doCheck = false;

  meta = {
    description = "Pure-Python Java Keystore (JKS) library";
    changelog = "https://github.com/kurtbrose/pyjks/blob/v${finalAttrs.version}/CHANGELOG.md";
    homepage = "https://github.com/kurtbrose/pyjks";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
})

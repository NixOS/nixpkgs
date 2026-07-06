{
  lib,
  bleak,
  buildPythonPackage,
  cryptography,
  esptool,
  fetchPypi,
  netifaces,
  pyserial,
  replaceVars,
  setuptools,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "rns";
  version = "1.3.7";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "rns";
    version = finalAttrs.version;
    hash = "sha256-Z1fbZcCvISs4a35EuV7aTjbWsRyug0JYvG0tEdrG4SU=";
  };

  patches = [
    (replaceVars ./unvendor-esptool.patch {
      esptool = lib.getExe esptool;
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    bleak
    cryptography
    netifaces
    pyserial
  ];

  pythonImportsCheck = [ "RNS" ];

  nativeCheckInputs = [ versionCheckHook ];

  versionCheckProgram = "${placeholder "out"}/bin/rncp";

  meta = {
    description = "Cryptography-based networking stack for wide-area networks";
    homepage = "https://reticulum.network";
    changelog = "https://github.com/markqvist/Reticulum/blob/${finalAttrs.version}/Changelog.md";
    license = lib.licenses.reticulum;
    maintainers = with lib.maintainers; [
      drupol
      fab
      qbit
    ];
  };
})

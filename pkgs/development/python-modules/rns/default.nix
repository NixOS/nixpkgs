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
  version = "1.3.8";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "rns";
    version = finalAttrs.version;
    hash = "sha256-1cHzlJOqm3WrZ7g5l9StW9NX5n6dYp/6KU4xov/eNH0=";
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

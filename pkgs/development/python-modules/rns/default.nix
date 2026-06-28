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
  version = "1.3.5";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "rns";
    version = finalAttrs.version;
    hash = "sha256-YxReocD6Ump5FMCnLEqCJ5tZcZh1kYsFWNBJ0pGYzuM=";
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

{
  lib,
  bleak,
  buildPythonPackage,
  cryptography,
  esptool,
  fetchFromGitHub,
  netifaces,
  pyserial,
  replaceVars,
  setuptools,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "rns";
  version = "1.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "Reticulum";
    tag = finalAttrs.version;
    hash = "sha256-21ym6R2zPxm8Z4zO6g/ZA4/A4S0SmwhOEqC6B+DTpOI=";
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
    changelog = "https://github.com/markqvist/Reticulum/blob/${finalAttrs.src.tag}/Changelog.md";
    # Reticulum License
    # https://github.com/markqvist/Reticulum/blob/master/LICENSE
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      fab
      qbit
    ];
  };
})

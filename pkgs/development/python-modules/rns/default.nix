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

buildPythonPackage rec {
  pname = "rns";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "Reticulum";
    tag = version;
    hash = "sha256-55fCmd1ihwvXQpsvEQ4xJH1p5aFEiUJZI7kE0LQX6WQ=";
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

  nativeCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/rncp";
  versionCheckProgramArg = "--version";

  meta = {
    description = "Cryptography-based networking stack for wide-area networks";
    homepage = "https://reticulum.network";
    changelog = "https://github.com/markqvist/Reticulum/blob/${src.tag}/Changelog.md";
    # Reticulum License
    # https://github.com/markqvist/Reticulum/blob/master/LICENSE
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      fab
      qbit
    ];
  };
}

{
  lib,
  buildPythonPackage,
  cryptography,
  esptool,
  fetchFromGitHub,
  netifaces,
  pyserial,
  pythonOlder,
  replaceVars,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rns";
  version = "0.8.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "Reticulum";
    rev = "refs/tags/${version}";
    hash = "sha256-LvtiK/j6EuXqBOj04x6aWoLOfhukFQxVsEzT/SWvcHU=";
  };

  patches = [
    (replaceVars ./unvendor-esptool.patch {
      esptool = lib.getExe esptool;
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    netifaces
    pyserial
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "RNS" ];

  meta = with lib; {
    description = "Cryptography-based networking stack for wide-area networks";
    homepage = "https://github.com/markqvist/Reticulum";
    changelog = "https://github.com/markqvist/Reticulum/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      fab
      qbit
    ];
  };
}

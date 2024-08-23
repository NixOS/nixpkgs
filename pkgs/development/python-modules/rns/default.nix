{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  netifaces,
  pyserial,
  python,
  pythonOlder,
  replaceVars,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rns";
  version = "0.7.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "Reticulum";
    rev = "refs/tags/${version}";
    hash = "sha256-TWaDRJQ695kjoKjWQeAO+uxSZGgQiHoWYIsS+XnYVOQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    netifaces
    pyserial
  ];

  # Module has no tests
  doCheck = false;

  patches = [
    (replaceVars ./fix-generated-shebang.patch {
      python = lib.getExe (python.withPackages (ps: [ ps.pyserial ]));
    })
  ];

  pythonImportsCheck = [ "RNS" ];

  meta = with lib; {
    description = "Cryptography-based networking stack for wide-area networks";
    homepage = "https://github.com/markqvist/Reticulum";
    changelog = "https://github.com/markqvist/Reticulum/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

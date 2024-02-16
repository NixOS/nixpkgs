{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, netifaces
, pyserial
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "rns";
  version = "0.7.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "Reticulum";
    rev = "refs/tags/${version}";
    hash = "sha256-o4+wHkkH0jUzq6Co0bru7NwvVxiV6xrggfHlQsjsWso=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cryptography
    netifaces
    pyserial
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "RNS"
  ];

  meta = with lib; {
    description = "Cryptography-based networking stack for wide-area networks";
    homepage = "https://github.com/markqvist/Reticulum";
    changelog = "https://github.com/markqvist/Reticulum/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
